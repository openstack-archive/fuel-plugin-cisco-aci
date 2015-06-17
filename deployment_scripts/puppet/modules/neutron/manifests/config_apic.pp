#Class neutron::config_apic
class neutron::config_apic (
    $apic_system_id                     = '',
    $apic_hosts                         = '10.0.0.1',
    $apic_username                      = 'admin',
    $apic_password                      = 'password',
    $static_config                      = '',
    $additional_config                  = '',
    $ext_net_enable                     = false,
    $ext_net_name                       = 'ext',
    $ext_net_switch                     = '101',
    $ext_net_port                       = '1/1',
    $ext_net_subnet                     = '10.0.0.0/24',
    $ext_net_gateway                    = '10.0.0.1',
    $ext_net_config                     = false,
    $pre_existing_vpc                   = true,
    $pre_existing_l3_context            = true,
    $shared_context_name                = '',
    $apic_external_network              = '',
    $pre_existing_external_network_on   = '',
    $external_epg                       = '',
){

    $additional_config_hash = hash(split($additional_config, '[\n=]'))
    $additional_config_options = keys($additional_config_hash)

    define additional_configuration($option = $name) {
        neutron_plugin_ml2_cisco {
            $option: value => $neutron::config_apic::additional_config_hash[$option];
        }
    }

    $static_config_hash = hash(split($static_config, '[\n=]'))
    $static_config_options = keys($static_config_hash)

    define static_configuration($option = $name) {
        neutron_plugin_ml2_cisco {
            $option: value => $neutron::config_apic::static_config_hash[$option];
        }
    }

    if ($ext_net_config == false) {
        $apic_ext_net = $apic_external_network
    }

    if ($pre_existing_vpc == true) {
        $apic_provision_infra_on       = 'False'
        $apic_provision_hostlinks_on   = 'False'
    }else {
        $apic_provision_infra_on       = 'True'
        $apic_provision_hostlinks_on   = 'True'
    }

    neutron_plugin_ml2_cisco {
        'DEFAULT/apic_system_id':                              value => $apic_system_id;
        'ml2_cisco_apic/apic_hosts':                           value => $apic_hosts;
        'ml2_cisco_apic/apic_username':                        value => $apic_username;
        'ml2_cisco_apic/apic_password':                        value => $apic_password;
        'ml2_cisco_apic/apic_name_mapping':                    value => 'use_name' ;
        'ml2_cisco_apic/root_helper':                          value => 'sudo';
        'ml2_cisco_apic/apic_provision_infra':                 value => $apic_provision_infra_on;
        'ml2_cisco_apic/apic_provision_hostlinks':             value => $apic_provision_hostlinks_on;
        "apic_external_network:${apic_ext_net}/preexisting":   value => $pre_existing_external_network_on;
        "apic_external_network:${apic_ext_net}/external_epg":  value => $external_epg;
    }

    additional_configuration { $additional_config_options: }
    static_configuration { $static_config_options: }

    if ($pre_existing_l3_context == true) {
        neutron_plugin_ml2_cisco {
            'ml2_cisco_apic/shared_context_name':  value => $shared_context_name;
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
