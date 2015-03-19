#Class heat::ha_services
class heat::ha_services (
  $enabled  = true,
) {

    include heat::params

    if $enabled {
        $service_ensure = 'running'
    } else {
        $service_ensure = 'stopped'
    }

    service { 'heat-api':
        ensure     => $service_ensure,
        name       => $::heat::params::api_service_name,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => 'heat',
    }
    service { 'heat-api-cloudwatch':
        ensure     => $service_ensure,
        name       => $::heat::params::api_cloudwatch_service_name,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => 'heat',
    }
    service { 'heat-api-cfn':
        ensure     => $service_ensure,
        name       => $::heat::params::api_cfn_service_name,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        tag        => 'heat',
    }
    service { 'heat-engine':
        ensure     => $service_ensure,
        name       => $::heat::params::engine_ha_service_name,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        provider   => 'pacemaker',
        tag        => 'heat',
    }

    Heat_config<||> ~> Service<| tag == 'heat' |>
}
