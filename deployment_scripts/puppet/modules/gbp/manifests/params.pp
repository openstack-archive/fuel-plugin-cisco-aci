#Class gbp::params
class gbp::params {

    $dbsync_command = 'gbp-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head'

    case $::osfamily {
        'RedHat': {
            $package_gbp_client     = 'python-gbpclient'
            $package_gbp_manage     = 'openstack-neutron-gbp'
            $package_gbp_heat       = 'openstack-heat-gbp'
            $package_gbp_horizon    = 'openstack-dashboard-gbp'
            $gbp_heat_plugin_path   = '/usr/lib/python2.6/site-packages/gbpautomation/heat'
        }

        'Debian': {
            $package_gbp_client     = 'python-python-group-based-policy-client'
            $package_gbp_manage     = 'python-group-based-policy'
            $package_gbp_heat       = 'python-group-based-policy-automation'
            $package_gbp_horizon    = 'python-group-based-policy-ui'
            $gbp_horizon_project    = '/usr/lib/python2.7/dist-packages/gbpui'
            $gbp_heat_plugin_path   = '/usr/lib/python2.7/site-packages/gbpautomation/heat'
        }

        default: {
            fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
        }
    }
}
