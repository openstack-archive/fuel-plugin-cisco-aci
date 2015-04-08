#Class neutron::config_apic
class neutron::config_apic (
    $apic_hosts         = '10.0.0.1',
    $apic_username      = 'admin',
    $apic_password      = 'password',
    $static_config      = '',
    $additional_config  = '',
    $ext_net_enable     = false,
    $ext_net_name       = 'ext',
    $ext_net_switch     = '101',
    $ext_net_port       = '1/1',
    $ext_net_subnet     = '10.0.0.0/24',
    $ext_net_gateway    = '10.0.0.1',
){

    neutron_plugin_ml2_cisco {
        'DEFAULT/apic_system_id':           value => 'openstack';
        'ml2_cisco_apic/apic_hosts':        value => $apic_hosts;
        'ml2_cisco_apic/apic_username':     value => $apic_username;
        'ml2_cisco_apic/apic_password':     value => $apic_password;
        'ml2_cisco_apic/apic_name_mapping': value => 'use_name' ;
    }
    if $::osfamily == 'RedHat' {
        neutron_plugin_ml2_cisco {
            'ml2_cisco_apic/root_helper':   value => 'sudo';
        }
    }
    if !empty($additional_config) {
        file_line{ 'additional_config':
            path => '/etc/neutron/plugins/ml2/ml2_conf_cisco.ini',
            line => $additional_config,
        }
    }
    if !empty($static_config) {
        file_line{ 'static_config':
            path => '/etc/neutron/plugins/ml2/ml2_conf_cisco.ini',
            line => $static_config,
        }
    }
    if ($ext_net_enable == true){
        neutron_plugin_ml2_cisco {
            "apic_external_network:${ext_net_name}/switch":       value => $ext_net_switch;
            "apic_external_network:${ext_net_name}/port":         value => $ext_net_port;
            "apic_external_network:${ext_net_name}/cidr_exposed": value => $ext_net_subnet;
            "apic_external_network:${ext_net_name}/gateway_ip":   value => $ext_net_gateway;

        }
    }
}
