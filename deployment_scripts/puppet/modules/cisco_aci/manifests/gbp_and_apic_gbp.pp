#Class cisco_aci::gbp_and_apic_gbp
class cisco_aci::gbp_and_apic_gbp (
    $ha_prefix                          = '',
    $role                               = 'compute',
    $use_lldp                           = true,
    $apic_system_id                     = '',
    $apic_hosts                         = '10.0.0.1',
    $apic_username                      = 'admin',
    $apic_password                      = 'password',
    $static_config                      = '',
    $additional_config                  = '',
    $service_plugins                    = 'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin,gbpservice.neutron.services.grouppolicy.plugin.GroupPolicyPlugin,gbpservice.neutron.services.servicechain.servicechain_plugin.ServiceChainPlugin',
    $mechanism_drivers                  = 'openvswitch,apic_gbp',
    $policy_drivers                     = 'implicit_policy,apic',
    $admin_username                     = 'admin',
    $admin_password                     = 'admin',
    $admin_tenant                       = 'admin',
    $ext_net_enable                     = false,
    $ext_net_config                     = '',
    $ext_net_name                       = 'ext',
    $ext_net_switch                     = '101',
    $ext_net_port                       = '1/1',
    $ext_net_subnet                     = '10.0.0.0/24',
    $ext_net_gateway                    = '10.0.0.1',
    $management_vip                     = '',
    $db_connection                      = '',
    $pre_existing_vpc                   = true,
    $pre_existing_l3_context            = true,
    $shared_context_name                = '',
    $apic_external_network              = '',
    $pre_existing_external_network_on   = '',
    $external_epg                       = '',
){
    include 'apic::params'
    include 'apic::api'

    if ($ext_net_enable == true) {
        $apic_net_name = $ext_net_name
    }else{
        $apic_net_name = $apic_external_network
    }

    case $role {
        /controller/: {
            if $use_lldp {
                include 'apic::svc_agent'
            }
            include 'neutron::services::apic_server'
            include "neutron::services::${ha_prefix}agents"
            include 'gbp::heat'
            include "heat::${ha_prefix}services"
            include 'gbp::horizon'
            include 'gbp::client'
            include 'gbp::manage'
            class {'neutron::config_auth':
                admin_username => $admin_username,
                admin_password => $admin_password,
                admin_tenant   => $admin_tenant,
            }
            if ($role == 'primary-controller' and $ext_net_enable == true){
                class {'neutron::network':
                    tenant_name     => $admin_tenant,
                    ext_net_name    => $ext_net_name,
                    ext_net_subnet  => $ext_net_subnet,
                    ext_net_gateway => $ext_net_gateway,
                }
            }
        }
        'compute': {
            include 'neutron::services::ovs_agent'
        }
        default: {
        }
    }

    if $use_lldp {
        include 'lldp'
        include 'apic::host_agent'

    }

    class {'gbp::config':
        policy_drivers => $policy_drivers,
    }

    class {'neutron::config':
        service_plugins   => $service_plugins,
        mechanism_drivers => $mechanism_drivers,
        db_connection     => $db_connection,
    }

    class {'neutron::config_apic':
        apic_system_id                     => $apic_system_id,
        apic_hosts                         => $apic_hosts,
        apic_username                      => $apic_username,
        apic_password                      => $apic_password,
        static_config                      => $static_config,
        additional_config                  => $additional_config,
        ext_net_enable                     => $ext_net_enable,
        ext_net_name                       => $apic_external_network,
        ext_net_switch                     => $ext_net_switch,
        ext_net_port                       => $ext_net_port,
        ext_net_subnet                     => $ext_net_subnet,
        ext_net_gateway                    => $ext_net_gateway,
        ext_net_config                     => $ext_net_config,
        pre_existing_vpc                   => $pre_existing_vpc,
        pre_existing_l3_context            => $pre_existing_l3_context,
        shared_context_name                => $shared_context_name,
        apic_external_network              => $apic_net_name,
        pre_existing_external_network_on   => $pre_existing_external_network_on,
        external_epg                       => $external_epg,
    }
}
