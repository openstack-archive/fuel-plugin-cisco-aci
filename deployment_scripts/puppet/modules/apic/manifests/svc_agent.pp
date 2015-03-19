#Class apic::svc_agent
class apic::svc_agent (
    $package_ensure = 'present',
    $enabled        = true,
    $manage_service = true,
){
    include apic::params

    if $manage_service {
        if $enabled {
            $service_ensure = 'running'
        } else {
            $service_ensure = 'stopped'
        }
    }

    Package['apic_svc_agent']       -> Neutron_config<||>
    Package['apic_svc_agent']       -> Neutron_plugin_ml2<||>
    Package['apic_svc_agent']       -> Neutron_plugin_ml2_cisco<||>
    Neutron_config<||>              ~> Service['apic-svc-agent']
    Neutron_plugin_ml2<||>          ~> Service['apic-svc-agent']
    Neutron_plugin_ml2_cisco<||>    ~> Service['apic-svc-agent']
    File_line<||>                   ~> Service['apic-svc-agent']

    package { 'apic_svc_agent':
        ensure => $package_ensure,
        name   => $::apic::params::package_apic_svc,
    }

    service { 'apic-svc-agent':
        ensure     => $service_ensure,
        name       => $::apic::params::service_apic_svc_agent,
        enable     => $enabled,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['apic_svc_agent'],
    }

}
