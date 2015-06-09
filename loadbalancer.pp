class { 'haproxy': }

#
# Stats
#
haproxy::listen { 'stats':
  collect_exported => false,
  ipaddress        => '0.0.0.0',
  ports            => '9000',
  options          => {
    'mode'          => 'http',
    'stats'         => 'enable',
    'stats uri'     => '/',
    'stats refresh' => '1s',
  },
}

#
# Main frontend
#
haproxy::listen { 'http':
  collect_exported => false,
  ipaddress        => '0.0.0.0',
  ports            => '80',
  options          => {
    'timeout connect' => '500',  
  },
}

haproxy::balancermember { 'backend00':
  listening_service => 'http',
  server_names      => 'master00.example.com',
  ipaddresses       => '192.168.0.200',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend01':
  listening_service => 'http',
  server_names      => 'master01.example.com',
  ipaddresses       => '192.168.0.201',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend02':
  listening_service => 'http',
  server_names      => 'master02.example.com',
  ipaddresses       => '192.168.0.202',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend03':
  listening_service => 'http',
  server_names      => 'master03.example.com',
  ipaddresses       => '192.168.0.203',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend04':
  listening_service => 'http',
  server_names      => 'master04.example.com',
  ipaddresses       => '192.168.0.204',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend05':
  listening_service => 'http',
  server_names      => 'master05.example.com',
  ipaddresses       => '192.168.0.205',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend06':
  listening_service => 'http',
  server_names      => 'master06.example.com',
  ipaddresses       => '192.168.0.206',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend07':
  listening_service => 'http',
  server_names      => 'master07.example.com',
  ipaddresses       => '192.168.0.207',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend08':
  listening_service => 'http',
  server_names      => 'master08.example.com',
  ipaddresses       => '192.168.0.208',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend09':
  listening_service => 'http',
  server_names      => 'master09.example.com',
  ipaddresses       => '192.168.0.209',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend10':
  listening_service => 'http',
  server_names      => 'master10.example.com',
  ipaddresses       => '192.168.0.210',
  ports             => '80',
  options           => 'check',
}

haproxy::balancermember { 'backend11':
  listening_service => 'http',
  server_names      => 'master11.example.com',
  ipaddresses       => '192.168.0.211',
  ports             => '80',
  options           => 'check',
}
