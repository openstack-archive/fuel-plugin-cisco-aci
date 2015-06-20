Puppet::Parser::Functions::newfunction(
    :neutron_service_plugins,
    :type => :rvalue,
    :doc => 'Allows to append or replace plugins in service_plugins list, replacement: neutron_service_plugins r <old_value>:<new_value_1>,<new_value_n>; appending: neutron_service_plugins a <value_1>,<value_2>,<value_n>'
) do |args|
    action      = args[0]
    tgt         = args[1]
    conf        = '/etc/neutron/neutron.conf' unless conf = args[2]
    fail "File: '#{conf}' does not exist?" unless File.exist? conf
    if (File.foreach(conf).grep /^service_plugins/).first
        plugins_list = ((((File.foreach(conf).grep /^service_plugins/).first.chomp).split('=')).last).split(',')
    else
        notice ('No service_plugins in use')
        return nil
    end
    rpl = tgt.to_s.split(':')
    if action == 'r'
        fail "Wrong arguments number for replacement" if rpl.size != 2
        if plugins_list.include? rpl[0]
            new_plugins = rpl[1].split(',')
            plugin_string = plugins_list.collect { |i| (i == rpl[0]) ? new_plugins : i }.flatten.uniq.join(',')
            return plugin_string
        else
            notice("No replacemant target found #{rpl[0]}")
            return rpl[1].to_s
        end
    elsif action == 'a'
        fail "Wrong arguments number for appending" if rpl.any?
        plugins_string = (plugins_list | rpl).uniq.join(',').to_s
        return plugins_string
      end
end