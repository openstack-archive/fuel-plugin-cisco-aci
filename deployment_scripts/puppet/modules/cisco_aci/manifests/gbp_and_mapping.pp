#Class cisco_aci::gbp_and_mapping
class cisco_aci::gbp_and_mapping (
    $ha_prefix          = '',
    $role               = 'compute',
    $service_plugins    = 'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin,gbpservice.neutron.services.grouppolicy.plugin.GroupPolicyPlugin,gbpservice.neutron.services.servicechain.servicechain_plugin.ServiceChainPlugin',
    $mechanism_drivers  = 'openvswitch',
    $policy_drivers     = 'implicit_policy,resource_mapping',
){
    include 'apic::api'

    case $role {
        /controller/: {
            include 'neutron::services::server'
            include "neutron::services::${ha_prefix}agents"
            include 'gbp::heat'
            include "heat::${ha_prefix}services"
            include 'gbp::horizon'
            include 'gbp::client'
            include 'gbp::manage'
        }
        'compute': {
            include 'neutron::services::ovs_agent'
        }
        default: {
        }
    }

    class {'gbp::config':
        policy_drivers => $policy_drivers,
    }

    class {'neutron::config':
        service_plugins   => $service_plugins,
        mechanism_drivers => $mechanism_drivers,
    }

}
