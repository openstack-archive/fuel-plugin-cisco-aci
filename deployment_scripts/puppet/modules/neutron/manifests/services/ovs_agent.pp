#Class neutron::services::ovs_agent
class neutron::services::ovs_agent (
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

    service { 'neutron-ovs-agent':
        ensure     => $service_ensure,
        name       => $::neutron::params::service_ovs_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
    }

    Neutron_config<||>              ~> Service['neutron-ovs-agent']
    Neutron_plugin_ml2<||>          ~> Service['neutron-ovs-agent']
    Neutron_plugin_ml2_cisco<||>    ~> Service['neutron-ovs-agent']
    File_line<||>                   ~> Service['neutron-ovs-agent']

}
