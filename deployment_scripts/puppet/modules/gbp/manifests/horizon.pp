#Class gbp::horizon
class gbp::horizon (
    $package_ensure = 'present',
){
    include gbp::params

    $enable_project = ['_50_gbp_project_add_panel_group.py','_60_gbp_project_add_panel.py','_61_gbp_project_add_panel.py','_62_gbp_project_add_panel.py','_63_gbp_project_add_panel.py']

    package { 'gbp_horizon':
        ensure => $package_ensure,
        name   => $::gbp::params::package_gbp_horizon,
    }

    horizon::project{$enable_project:
        project_dir  => $::gbp::params::gbp_horizon_project,
    }
}
