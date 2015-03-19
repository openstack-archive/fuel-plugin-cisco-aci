#Class apic::host_agent
class apic::host_agent (
    $package_ensure     = 'present',
    $enabled            = true,
    $manage_service     = true,
){
    include apic::params

    if $manage_service {
        if $enabled {
            $service_ensure = 'running'
        } else {
            $service_ensure = 'stopped'
        }
    }

    package { 'apic_host_agent':
        ensure => $package_ensure,
        name   => $::apic::params::package_apic_agent,
    }

    service { 'apic-host-agent':
        ensure     => $service_ensure,
        name       => $::apic::params::service_apic_host_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['apic_host_agent'],
    }

    Package['apic_host_agent']      -> Neutron_config<||>
    Package['apic_host_agent']      -> Neutron_plugin_ml2<||>
    Package['apic_host_agent']      -> Neutron_plugin_ml2_cisco<||>
    Neutron_config<||>              ~> Service['apic-host-agent']
    Neutron_plugin_ml2<||>          ~> Service['apic-host-agent']
    Neutron_plugin_ml2_cisco<||>    ~> Service['apic-host-agent']
    File_line<||>                   ~> Service['apic-host-agent']

}
