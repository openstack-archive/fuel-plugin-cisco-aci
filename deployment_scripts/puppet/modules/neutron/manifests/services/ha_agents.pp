#Class neutron::services::ha_agents
class neutron::services::ha_agents (
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

    service {'neutron-dhcp-agent':
        ensure     => $service_ensure,
        name       => $::neutron::params::ha_dhcp_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => false,
        provider   => 'pacemaker',
        tag        => 'ha_agents',
    }

    service {'neutron-metadata-agent':
        ensure     => $service_ensure,
        name       => $::neutron::params::ha_metadata_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => false,
        provider   => 'pacemaker',
        tag        => 'ha_agents',
    }

    service {'neutron-plugin-openvswitch-agent':
        ensure     => $service_ensure,
        name       => $::neutron::params::ha_ovs_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => false,
        provider   => 'pacemaker',
        tag        => 'ha_agents',
    }

    service {'neutron-l3-agent':
        ensure     => $service_ensure,
        name       => $::neutron::params::ha_l3_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => false,
        provider   => 'pacemaker',
        tag        => 'ha_agents',
    }


    Neutron_config<||>              ~> Service<| tag == 'ha_agents' |>
    Neutron_plugin_ml2<||>          ~> Service<| tag == 'ha_agents' |>
    Neutron_plugin_ml2_cisco<||>    ~> Service<| tag == 'ha_agents' |>
    File_line<||>                   ~> Service<| tag == 'ha_agents' |>

}
