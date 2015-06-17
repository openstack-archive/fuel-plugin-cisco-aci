#Class apic::params
class apic::params {

    $package_apic_api                  = 'python-apicapi'
    $package_apic_svc                  = 'python-apicapi'
    $package_apic_agent                = 'python-apicapi'
    $package_neutron_ml2_driver_apic   = 'neutron-ml2-driver-apic'

    case $::osfamily {
        'RedHat': {
            $service_apic_svc_agent     = 'neutron-apic-service-agent'
            $service_apic_host_agent    = 'neutron-apic-host-agent'
        }

        'Debian': {
            $service_apic_svc_agent     = 'neutron-cisco-apic-service-agent'
            $service_apic_host_agent    = 'neutron-cisco-apic-host-agent'
        }

        default: {
            fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
        }
    }
}
