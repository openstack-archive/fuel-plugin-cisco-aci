#Class apic::params
class apic::params {

    $package_apic_api           = 'apicapi'

    case $::osfamily {
        'RedHat': {
            $service_apic_svc_agent     = 'neutron-apic-service-agent'
            $service_apic_host_agent    = 'neutron-apic-host-agent'
        }

        'Debian': {
            $service_apic_svc_agent     = 'neutron-driver-apic-svc'
            $service_apic_host_agent    = 'neutron-driver-apic-agent'
        }

        default: {
            fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
        }
    }
}
