
$role               = hiera('role')
$deployment_mode    = hiera('deployment_mode')
$cisco_aci_hash     = hiera('cisco_aci',{})
$access_hash        = hiera('access',{})
$management_vip     = hiera('management_vip')
$neutron_settings   = hiera('quantum_settings',{})
$db_connection      = "mysql://neutron:${neutron_settings['database']['passwd']}@${management_vip}/neutron?&read_timeout=60"

$ha_prefix = $deployment_mode ? {
    'ha_compact'    => 'ha_',
    default         => '',
}

if ($cisco_aci_hash['use_gbp'] == false and $cisco_aci_hash['use_apic'] == false){
    fail('Wrong configuration')
}

if ($cisco_aci_hash['use_gbp'] == false and $cisco_aci_hash['use_apic'] == true){
    if ($cisco_aci_hash['driver_type'] == 'ML2'){
        $install_type   = 'US1'
        $class_name     = 'generic_apic_ml2'
    }else{
        fail('Wrong configuration')
    }
}

if ($cisco_aci_hash['use_gbp'] == true and $cisco_aci_hash['use_apic'] == false){
    $install_type   = 'US2a'
    $class_name     = 'gbp_and_mapping'
}

if ($cisco_aci_hash['use_gbp'] == true and $cisco_aci_hash['use_apic'] == true){
    if ($cisco_aci_hash['driver_type'] == 'ML2'){
        $install_type   = 'US2b'
        $class_name     = 'gbp_and_apic_ml2'
    }elsif ($cisco_aci_hash['driver_type'] == 'GBP'){
        $install_type   = 'US3'
        $class_name     = 'gbp_and_apic_gbp'
    }
}

case $install_type {
    'US1': {
        class {'cisco_aci::generic_apic_ml2':
            ha_prefix                                => $ha_prefix,
            role                                     => $role,
            admin_username                           => $access_hash['user'],
            admin_password                           => $access_hash['password'],
            admin_tenant                             => $access_hash['tenant'],
            use_lldp                                 => $cisco_aci_hash['use_lldp'],
            apic_system_id                           => $cisco_aci_hash['apic_system_id'],
            apic_hosts                               => $cisco_aci_hash['apic_hosts'],
            apic_username                            => $cisco_aci_hash['apic_username'],
            apic_password                            => $cisco_aci_hash['apic_password'],
            static_config                            => $cisco_aci_hash['static_config'],
            additional_config                        => $cisco_aci_hash['additional_config'],
            ext_net_enable                           => $cisco_aci_hash['ext_net_enable'],
            ext_net_name                             => $cisco_aci_hash['ext_net_name'],
            ext_net_switch                           => $cisco_aci_hash['ext_net_switch'],
            ext_net_port                             => $cisco_aci_hash['ext_net_port'],
            ext_net_subnet                           => $cisco_aci_hash['ext_net_subnet'],
            ext_net_gateway                          => $cisco_aci_hash['ext_net_gateway'],
            db_connection                            => $db_connection,
            ext_net_config                           => $cisco_aci_hash['ext_net_enable'],
            pre_existing_vpc                         => $cisco_aci_hash['use_pre_existing_vpc'],
            pre_existing_l3_context                  => $cisco_aci_hash['use_pre_existing_l3context'],
            shared_context_name                      => $cisco_aci_hash['shared_context_name'],
            apic_external_network                    => $cisco_aci_hash['apic_external_network'],
            pre_existing_external_network_on         => $cisco_aci_hash['pre_existing_external_network_on'],
            external_epg                             => $cisco_aci_hash['external_epg'],
        }
    }
    'US2b','US3': {
        class {"cisco_aci::${class_name}":
            ha_prefix                                => $ha_prefix,
            role                                     => $role,
            admin_username                           => $access_hash['user'],
            admin_password                           => $access_hash['password'],
            admin_tenant                             => $access_hash['tenant'],
            use_lldp                                 => $cisco_aci_hash['use_lldp'],
            apic_system_id                           => $cisco_aci_hash['apic_system_id'],
            apic_hosts                               => $cisco_aci_hash['apic_hosts'],
            apic_username                            => $cisco_aci_hash['apic_username'],
            apic_password                            => $cisco_aci_hash['apic_password'],
            static_config                            => $cisco_aci_hash['static_config'],
            additional_config                        => $cisco_aci_hash['additional_config'],
            ext_net_enable                           => $cisco_aci_hash['ext_net_enable'],
            ext_net_name                             => $cisco_aci_hash['ext_net_name'],
            ext_net_switch                           => $cisco_aci_hash['ext_net_switch'],
            ext_net_port                             => $cisco_aci_hash['ext_net_port'],
            ext_net_subnet                           => $cisco_aci_hash['ext_net_subnet'],
            ext_net_gateway                          => $cisco_aci_hash['ext_net_gateway'],
            db_connection                            => $db_connection,
            ext_net_config                           => $cisco_aci_hash['ext_net_enable'],
            pre_existing_vpc                         => $cisco_aci_hash['use_pre_existing_vpc'],
            pre_existing_l3_context                  => $cisco_aci_hash['use_pre_existing_l3context'],
            shared_context_name                      => $cisco_aci_hash['shared_context_name'],
            apic_external_network                    => $cisco_aci_hash['apic_external_network'],
            pre_existing_external_network_on         => $cisco_aci_hash['pre_existing_external_network_on'],
            external_epg                             => $cisco_aci_hash['external_epg'],
        }
    }
    'US2a': {
        class {"cisco_aci::${class_name}":
            ha_prefix       => $ha_prefix,
            role            => $role,
            db_connection   => $db_connection,
        }
    }
    default: {
        fail("Wrong module ${module_name}")
    }
}
