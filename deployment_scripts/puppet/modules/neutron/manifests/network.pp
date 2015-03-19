#Class neutron::network
class neutron::network (
    $ensure             = 'present',
    $ext_net_name       = 'extnet',
    $ext_net_subnet     = '10.0.0.0/24',
    $ext_net_gateway    = '10.0.0.1',
    $shared             = true,
    $tenant_name        = 'admin',
) {

    neutron_network { $ext_net_name:
        ensure          => $ensure,
        router_external => true,
        tenant_name     => $tenant_name,
        shared          => $shared,
    }
    ->
    neutron_subnet { "${ext_net_name}__subnet":
        ensure       => $ensure,
        cidr         => $ext_net_subnet,
        network_name => $ext_net_name,
        tenant_name  => $tenant_name,
        gateway_ip   => $ext_net_gateway,
    }
    ->
    neutron_router { "${ext_net_name}__router":
        ensure      => $ensure,
        tenant_name => $tenant_name,
    }
    ->
    neutron_router_interface { "${ext_net_name}__router:${ext_net_name}__subnet":
        ensure => present,
    }

    Service<| title == 'neutron-server'|> -> Neutron_network<||>
    Service<| title == 'neutron-server'|> -> Neutron_subnet<||>
    Service<| title == 'neutron-server'|> -> Neutron_router<||>
    Service<| title == 'neutron-server'|> -> Neutron_router_interface<||>
}
