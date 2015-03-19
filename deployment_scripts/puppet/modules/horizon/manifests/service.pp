#
class horizon::service(
    $package_ensure         = present,
) {

    include horizon::params

    service { 'httpd':
        ensure => 'running',
        name   => $::horizon::params::http_service,
        enable => true
    }
}
