#Class lldp::params

class lldp::params {

    $autoupdate = false
    $package_name = 'lldpd'
    $service_name = 'lldpd'

    case $::osfamily {
        'Debian': {
            $config_file_path = '/etc/default/lldpd'
            $config_file_data = '#Generated by puppet <%= "\n" %>DAEMON_ARGS="-c -I eth*"<%= "\n" %>'
        }
        'RedHat': {
            $config_file_path = '/etc/sysconfig/lldpd'
            $config_file_data = '#Generated by puppet <%= "\n" %>LLDPD_OPTIONS="-c -I eth*"<%= "\n" %>'
        }
        default: { fail("lldp: unsuported OS family ${::osfamily}") }
    }
}
