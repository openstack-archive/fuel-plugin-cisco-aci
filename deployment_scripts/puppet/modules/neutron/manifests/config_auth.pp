#Class neutron::config_auth
class neutron::config_auth (
    $admin_username   = 'admin',
    $admin_password   = 'admin',
    $admin_tenant     = 'admin',
){

    neutron_config {
        'keystone_authtoken/admin_user':            value => $admin_username;
        'keystone_authtoken/admin_password':        value => $admin_password;
        'keystone_authtoken/admin_tenant_name':     value => $admin_tenant;
    }
}
