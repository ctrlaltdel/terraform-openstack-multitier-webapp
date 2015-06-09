resource "openstack_compute_keypair_v2" "keypair1" {
    name = "tf-keypair-1"
    public_key = "${file("id_rsa.pub")}"
}

/*
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name = "my_secgroup"
  description = "my security group"
  rule {
    ip_protocol = "tcp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }
}
*/

#
# Network
#

#
# Create a Network
#
resource "openstack_networking_network_v2" "tf_network" {
    region = ""
    name = "tf_network"
    admin_state_up = "true"
}
 
#
# Create a subnet in our new network
# Notice here we use a TF variable for the name of our network above.
#
resource "openstack_networking_subnet_v2" "tf_net_sub1" {
    region = ""
    network_id = "${openstack_networking_network_v2.tf_network.id}"
    cidr = "192.168.0.0/24"
    ip_version = 4
    dns_nameservers = [
      "8.8.8.8",
      "8.8.4.4"
    ]
}
 
#
# Create a router for our network
#
resource "openstack_networking_router_v2" "tf_router1" {
    region = ""
    name = "tf_router1"
    admin_state_up = "true"
    external_gateway = "b052d4e5-295f-47aa-b400-63c8ae15d1d9"
}
 
#
# Attach the Router to our Network via an Interface
#
resource "openstack_networking_router_interface_v2" "tf_rtr_if_1" {
    region = ""
    router_id = "${openstack_networking_router_v2.tf_router1.id}"
    subnet_id = "${openstack_networking_subnet_v2.tf_net_sub1.id}"
}

#
# Load-balancer
#

resource "openstack_compute_floatingip_v2" "load-balancer" {
  pool = "public"
  depends_on = ["openstack_networking_router_interface_v2.tf_rtr_if_1"]
}

output "address" {
  value = "${openstack_compute_floatingip_v2.load-balancer.address}"
}

resource "openstack_compute_instance_v2" "load-balancer" {
  name = "load-balancer"
  image_name = "ubuntu-1404-latest"
  flavor_name = "m1.small"
  key_pair = "tf-keypair-1"
  security_groups = ["all"]

  network {
    uuid = "${openstack_networking_network_v2.tf_network.id}"
    fixed_ip_v4 = "192.168.0.100"
  }

  floating_ip = "${openstack_compute_floatingip_v2.load-balancer.address}"

  connection {
    user = "ubuntu"
    key_file = "id_rsa"
  }

  provisioner "file" {
    source = "loadbalancer.pp"
    destination = "/tmp/site.pp"
  }

  provisioner remote-exec {
    inline = [
      "while :; do test -f /run/cloud-init/result.json && break; sleep 1; done", # Wait for cloud-init to finish
      "sudo apt-get -q update",
      "sudo apt-get -qyy install puppet",
      "sudo puppet module install puppetlabs/haproxy",
      "sudo puppet apply -v /tmp/site.pp",
    ]
  }
}

#
# Application servers
#

variable "instance_ips" {
  default = {
    "0" = "192.168.0.200"
    "1" = "192.168.0.201"
    "2" = "192.168.0.202"
    "3" = "192.168.0.203"
    "4" = "192.168.0.204"
    "5" = "192.168.0.205"
    "6" = "192.168.0.206"
    "7" = "192.168.0.207"
    "8" = "192.168.0.208"
    "9" = "192.168.0.209"
    "10" = "192.168.0.210"
    "11" = "192.168.0.211"
  }
}

resource "openstack_compute_instance_v2" "app" {
  name = "app"
  image_name = "ubuntu-1504-latest"
  flavor_name = "m1.tiny"
  key_pair = "tf-keypair-1"
  security_groups = ["all"]


  network {
    uuid = "${openstack_networking_network_v2.tf_network.id}"
    fixed_ip_v4 = "${lookup(var.instance_ips, count.index)}"
  }

  user_data = "#!/bin/sh\napt-get -q update\napt-get -qyy install apache2\necho 'App server #${count.index}' > /var/www/html/index.html"

  count = 5
}

