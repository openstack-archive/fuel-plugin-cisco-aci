#Class neutron::services::agents
class neutron::services::agents (
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
        tag        => 'neutron_agents'
    }

    service { 'neutron-metadata-agent':
        ensure     => $service_ensure,
        name       => $::neutron::params::service_metadata_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => 'neutron_agents'
    }

    service { 'neutron-dhcp-agent':
        ensure     => $service_ensure,
        name       => $::neutron::params::service_dhcp_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => 'neutron_agents'
    }

    service { 'neutron-l3-agent':
        ensure     => $service_ensure,
        name       => $::neutron::params::service_l3_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => 'neutron_agents'
    }

    Neutron_config<||>              ~> Service<| tag == 'neutron_agents' |>
    Neutron_plugin_ml2<||>          ~> Service<| tag == 'neutron_agents' |>
    Neutron_plugin_ml2_cisco<||>    ~> Service<| tag == 'neutron_agents' |>
    File_line<||>                   ~> Service<| tag == 'neutron_agents' |>

}
