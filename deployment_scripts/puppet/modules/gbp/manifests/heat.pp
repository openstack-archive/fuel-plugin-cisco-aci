#Class gbp::heat
class gbp::heat (
    $package_ensure = 'present',
){
    include gbp::params

    Package['gbp_heat'] -> Heat_config<||>

    package { 'gbp_heat':
        ensure => $package_ensure,
        name   => $::gbp::params::package_gbp_heat,
    }

    heat_config{
        'DEFAULT/plugin_dirs'  : value => $::gbp::params::gbp_heat_plugin_path;
    }

}
