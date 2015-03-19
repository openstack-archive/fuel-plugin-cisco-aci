#Class apic::api
class apic::api (
  $package_ensure  = 'present',
) {

    include apic::params
    package { 'apic_api':
        ensure => $package_ensure,
        name   => $::apic::params::package_apic_api,
    }

}
