#Class apic::host_agent
class apic::host_agent (
    $package_ensure     = 'present',
    $enabled            = true,
    $manage_service     = true,
) {
    include apic::params
    include apic::api

    if $manage_service {
        if $enabled {
            $service_ensure = 'running'
        } else {
            $service_ensure = 'stopped'
        }
    }

    package { 'apic_ml2_driver':
        ensure => $package_ensure,
        name   => $::apic::params::package_neutron_ml2_driver_apic,
    }

    service { 'apic-host-agent':
        ensure     => $service_ensure,
        name       => $::apic::params::service_apic_host_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['apic_api'],
    }

    Package['apic_api']            -> Package['apic_ml2_driver']
    Package['apic_api']            -> Neutron_config<||>
    Package['apic_api']            -> Neutron_plugin_ml2<||>
    Package['apic_api']            -> Neutron_plugin_ml2_cisco<||>
    Neutron_config<||>             ~> Service['apic-host-agent']
    Neutron_plugin_ml2<||>         ~> Service['apic-host-agent']
    Neutron_plugin_ml2_cisco<||>   ~> Service['apic-host-agent']
    File_line<||>                  ~> Service['apic-host-agent']

}
