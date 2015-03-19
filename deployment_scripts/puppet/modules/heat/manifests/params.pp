# Parameters for puppet-heat
#
class heat::params {

  $dbsync_command =
    'heat-manage --config-file /etc/heat/heat.conf db_sync'

  case $::osfamily {
    'RedHat': {
      # service names
      $api_service_name = 'openstack-heat-api'
      $api_cloudwatch_service_name = 'openstack-heat-api-cloudwatch'
      $api_cfn_service_name = 'openstack-heat-api-cfn'
      $engine_service_name = 'openstack-heat-engine'
      $engine_ha_service_name = 'p_openstack-heat-engine'
    }
    'Debian': {
      # service names
      $api_service_name = 'heat-api'
      $api_cloudwatch_service_name = 'heat-api-cloudwatch'
      $api_cfn_service_name = 'heat-api-cfn'
      $engine_service_name = 'heat-engine'
      $engine_ha_service_name = 'p_heat-engine'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: \
${::operatingsystem}, module ${module_name} only support osfamily \
RedHat and Debian")
    }
  }
}
