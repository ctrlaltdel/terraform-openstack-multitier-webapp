Usage
=====

1. Configure your OpenStack credentials in ``override.tf``

```
provider "openstack" {
    user_name   = "john"
    tenant_name = "sandbox"
    password    = "blah"
    auth_url    = "https://cloud.local:5000/v2.0"
}

resource "openstack_networking_router_v2" "tf_router1" {
    external_gateway = "00000000-0000-0000-0000-000000000000" # UUID of the existing external network to use
}
```

2. Create a password-less SSH key in ``id_rsa`` and ``id_rsa.pub`

```
$ ssh-keygen -t rsa -f id_rsa
```

3. ``$ terraform apply``

TODO
====

* Automatically discover existing external networks
* Automatically generate SSH keys
* Security group issues
