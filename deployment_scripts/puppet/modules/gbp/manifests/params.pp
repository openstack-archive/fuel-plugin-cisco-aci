#Class gbp::params
class gbp::params {

    $dbsync_command = 'gbp-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head'

    case $::osfamily {
        'RedHat': {
        }

        'Debian': {
            $package_gbp_client     = 'python-python-group-based-policy-client'
            $package_gbp_manage     = 'python-group-based-policy'
            $package_gbp_heat       = 'python-group-based-policy-automation'
            $package_gbp_horizon    = 'python-group-based-policy-ui'
            $gbp_horizon_project    = '/usr/lib/python2.7/dist-packages/gbpui'
        }

        default: {
            fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
        }
    }
}
