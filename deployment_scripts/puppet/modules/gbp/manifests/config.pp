#Class gbp::config
class gbp::config (
    $policy_drivers   = '',
){
    neutron_config {
        'group_policy/policy_drivers':       value => $policy_drivers;
        'servicechain/servicechain_drivers': value => 'simplechain_driver';
        'quotas/default_quota':              value => '-1';
        'quotas/quota_network':              value => '-1';
        'quotas/quota_subnet':               value => '-1';
        'quotas/quota_port':                 value => '-1';
        'quotas/quota_security_group':       value => '-1';
        'quotas/quota_security_group_rule':  value => '-1';
        'quotas/quota_router':               value => '-1';
        'quotas/quota_floatingip':           value => '-1';
    }
}
