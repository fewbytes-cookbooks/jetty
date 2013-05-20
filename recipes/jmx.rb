#this recipe enables jmx access for jetty

node.default["jetty"]["jetty_extra_args"]["jmx"] = "OPTIONS=Server,jmx etc/jetty-jmx.xml"

template ::File.join(node["jetty"]["config_dir"], "jetty-jmx.xml") do
  owner node["jetty"]["user"]
  group node["jetty"]["group"]
  mode "0644"
  notifies :restart, "service[jetty]"
end
