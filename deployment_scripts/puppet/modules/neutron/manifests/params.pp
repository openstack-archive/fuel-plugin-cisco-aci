#Class neutron::params
class neutron::params {

    $ha_metadata_agent      = 'p_neutron-metadata-agent'
    $ha_dhcp_agent          = 'p_neutron-dhcp-agent'
    $ha_l3_agent            = 'p_neutron-l3-agent'
    $service_metadata_agent = 'neutron-metadata-agent'
    $service_dhcp_agent     = 'neutron-dhcp-agent'
    $service_l3_agent       = 'neutron-l3-agent'
    $service_neutron_server = 'neutron-server'

    case $::osfamily {
        'RedHat': {
            $service_ovs_agent      = 'neutron-openvswitch-agent'
            $ha_ovs_agent           = 'p_neutron-openvswitch-agent'
            $initd_file_path        = '/etc/sysconfig/neutron'
            $initd_file_template    = 'puppet:///modules/neutron/neutron'
        }

        'Debian': {
            $service_ovs_agent      = 'neutron-plugin-openvswitch-agent'
            $ha_ovs_agent           = 'p_neutron-plugin-openvswitch-agent'
            $initd_file_path        = '/etc/init/neutron-server.conf'
            $initd_file_template    = 'puppet:///modules/neutron/neutron-server.conf'
        }

        default: {
          fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
        }
    }
}
