#Class gbp::manage
class gbp::manage (
    $package_ensure = 'present',
){
    include gbp::params
    include neutron::services::server

    Exec['gbp_dbsync']  ~> Service['neutron-server']

    package { 'gbp_manage':
        ensure => $package_ensure,
        name   => $::gbp::params::package_gbp_manage,
    }

    exec { 'gbp_dbsync':
        command     => $::gbp::params::dbsync_command,
        path        => '/usr/bin',
        refreshonly => true,
        logoutput   => on_failure,
        require     => Package['gbp_manage'],
    }
}
