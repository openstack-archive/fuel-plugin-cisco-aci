#Class neutron::config

class neutron::config (
    $service_plugins    = 'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin',
    $mechanism_drivers  = 'openvswitch',
    $db_connection      = '',

){
    file_line {'neutron_nopasswd':
        ensure => present,
        line => 'neutron ALL=(ALL) NOPASSWD: ALL',
        path => '/etc/sudoers',
    }
    exec {'neutron_rootwrap':
        command => 'ln -s /usr/bin/neutron-rootwrap /usr/local/bin/neutron-rootwrap',
        path    => '/usr/local/bin/:/bin/',
        creates => '/usr/local/bin/neutron-rootwrap',
    }
    $service_plugin_set = neutron_service_plugins('r', "neutron.services.l3_router.l3_router_plugin.L3RouterPlugin:${service_plugins}")
    neutron_config {
        'DEFAULT/service_plugins':  value => $service_plugin_set;
        'DEFAULT/core_plugin':      value => 'neutron.plugins.ml2.plugin.Ml2Plugin';
        'database/connection':      value => $db_connection;
    }
    neutron_plugin_ml2 {
        'ml2/type_drivers':                     value => 'local,flat,vlan,gre,vxlan';
        'ml2/tenant_network_types':             value => 'vlan';
        'ml2/mechanism_drivers':                value => $mechanism_drivers;
        #'ml2_type_vlan/network_vlan_ranges':    value => "$physnets_dev:$vlan_range";
        'securitygroup/enable_security_group':  value => 'True';
        'securitygroup/firewall_driver':        value => 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver';
        #'ovs/integration_bridge':               value => "$int_bridge";
        #'ovs/bridge_mappings':                  value => "$physnets_dev:$int_bridge";
        #'ovs/enable_tunneling':                 value => 'False';
        'agent/polling_interval':               value => '2';
        'agent/l2_population':                  value => 'False';
        'agent/arp_responder':                  value => 'False';
    }
}
