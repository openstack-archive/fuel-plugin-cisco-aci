#Class neutron::services::server
class neutron::services::server (
    $enabled        = true,
    $manage_service = true,
){
    include neutron::params

    if $manage_service {
        if $enabled {
            $service_ensure = 'running'
        } else {
            $service_ensure = 'stopped'
        }
    }

    File['rootwrap']                ~> Service['neutron-server']
    Neutron_config<||>              ~> Service['neutron-server']
    Neutron_plugin_ml2<||>          ~> Service['neutron-server']
    Neutron_plugin_ml2_cisco<||>    ~> Service['neutron-server']
    File_line<||>                   ~> Service['neutron-server']

    file {'rootwrap':
        ensure => link,
        path   => '/usr/local/bin/neutron-rootwrap',
        target => '/usr/bin/neutron-rootwrap',
    }

    service { 'neutron-server':
        ensure     => $service_ensure,
        name       => $::neutron::params::service_neutron_server,
        enable     => $enabled,
        start      => '/usr/sbin/service neutron-server restart',
        pattern    => '/usr/bin/neutron-server'
    }
}