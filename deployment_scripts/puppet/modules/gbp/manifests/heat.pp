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
        'DEFAULT/plugin_dirs'  : value => '/usr/lib/python2.7/dist-packages/gbpautomation/heat';
    }

}
