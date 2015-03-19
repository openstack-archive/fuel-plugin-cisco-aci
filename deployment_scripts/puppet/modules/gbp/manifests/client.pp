#Class gbp::client
class gbp::client (
    $package_ensure = 'present',
){
    include gbp::params

    package { 'gbp_client':
        ensure => $package_ensure,
        name   => $::gbp::params::package_gbp_client,
    }
}
