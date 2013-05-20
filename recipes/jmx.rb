#this recipe enables jmx access for jetty

node.default["jetty"]["jetty_extra_args"]["jmx"] = "OPTIONS=Server,jmx etc/jetty-jmx.xml"
node.default["jetty"]["java_extra_options"]["jmx"] = [
    "-Dcom.sun.management.jmxremote",
    "-Xshare:off",
    "-Dcom.sun.management.jmxremote.ssl=false",
    "-Dcom.sun.management.jmxremote.authenticate=false",
    "-Dcom.sun.management.jmxremote.local.only=false",
    "-Djava.rmi.server.hostname=#{node["fqdn"]}",
].join(" ")

template ::File.join(node["jetty"]["config_dir"], "jetty-jmx.xml") do
  owner node["jetty"]["user"]
  group node["jetty"]["group"]
  mode "0644"
  notifies :restart, "service[jetty]"
end
