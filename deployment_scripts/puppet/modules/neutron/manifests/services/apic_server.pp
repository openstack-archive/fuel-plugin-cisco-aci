#Class neutron::services::apic_server
class neutron::services::apic_server (
    $enabled        = true,
    $manage_service = true,
){
    include neutron::params
    include neutron::services::server

    File['neutron_initd']   ~> Service['neutron-server']

    file {'neutron_initd':
        ensure => 'present',
        path   => $::neutron::params::initd_file_path,
        source => $::neutron::params::initd_file_template,
    }
}
