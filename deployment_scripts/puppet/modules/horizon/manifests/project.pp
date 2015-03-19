#
define horizon::project(
    $project_dir = '/tmp',
){
    include horizon::params
    include horizon::service

    File[$name]   ~> Service['httpd']

    file {$name:
        ensure => link,
        path   => "${::horizon::params::dashboard_enabled}/${name}",
        target => "${project_dir}/${name}",
    }
}
