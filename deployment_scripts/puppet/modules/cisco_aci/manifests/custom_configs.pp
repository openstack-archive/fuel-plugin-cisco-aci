#Class cisco_aci::custom_configs
class cisco_aci::custom_configs (
    $role               = '',
    $management_vip     = '',
    $n_user             = 'neutron',
    $n_passwd           = '',
    $r_timeout          = '',
) {

    include neutron::services::server
    notice("Executing on role: $role")

    neutron_config {
	'database/connection': value => "mysql://$n_user:$n_passwd@$management_vip/neutron?&read_timeout=$r_timeout";
    }

    Neutron_config<||> ~> Service['neutron-server']
}