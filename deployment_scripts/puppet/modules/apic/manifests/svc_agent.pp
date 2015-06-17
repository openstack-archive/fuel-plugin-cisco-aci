#Class apic::svc_agent
class apic::svc_agent (
    $package_ensure = 'present',
    $enabled        = true,
    $manage_service = true,
    $role           = '',
){
    include apic::params
    include apic::api

    Package['apic_api']             -> Neutron_config<||>
    Package['apic_api']             -> Neutron_plugin_ml2<||>
    Package['apic_api']             -> Neutron_plugin_ml2_cisco<||>

    if ($role =~ /controller/ ){
        if $manage_service {
            if $enabled {
                $service_ensure = 'running'
            } else {
                $service_ensure = 'stopped'
            }
        }
        service { 'apic-svc-agent':
            ensure     => $service_ensure,
            name       => $::apic::params::service_apic_svc_agent,
            enable     => $enabled,
            hasstatus  => true,
            hasrestart => true,
            require    => Package['apic_api'],
        }

        Neutron_config<||>              ~> Service['apic-svc-agent']
        Neutron_plugin_ml2<||>          ~> Service['apic-svc-agent']
        Neutron_plugin_ml2_cisco<||>    ~> Service['apic-svc-agent']
        File_line<||>                   ~> Service['apic-svc-agent']

    }else{
        exec {'disabling_cisco_svc_agent':
            command => "/bin/mv /etc/init/${$::apic::params::service_apic_svc_agent}.conf /etc/init/${$::apic::params::service_apic_svc_agent}.conf.disabled",
            onlyif  => "/usr/bin/test -f /etc/init/${$::apic::params::service_apic_svc_agent}.conf",
            creates => "/etc/init/${$::apic::params::service_apic_svc_agent}.conf.disabled",
        }
        ~>
        file {"/etc/init/${service_apic_svc_agent}.conf":
            ensure => absent,
        }
    }
}