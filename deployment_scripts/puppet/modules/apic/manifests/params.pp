#Class apic::params
class apic::params {

    case $::osfamily {
        'RedHat': {
        }

        'Debian': {
            $package_apic_svc           = 'neutron-driver-apic-svc'
            $package_apic_agent         = 'neutron-driver-apic-agent'
            $package_apic_api           = 'python-apicapi'
            $service_apic_svc_agent     = 'neutron-driver-apic-svc'
            $service_apic_host_agent    = 'neutron-driver-apic-agent'
        }

        default: {
            fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
        }
    }
}
