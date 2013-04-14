include_recipe "java"

directory node["jetty"]["log_dir"] do
  owner node["jetty"]["user"]
  mode "0755"
end

directory node["jetty"]["config_dir"] do
  mode "0755"
end

directory node["jetty"]["tmp_dir"] do
  mode "0755"
  recursive true
end

directory node["jetty"]["context_dir"] do
  owner node["jetty"]["user"]
  mode "0755"
end

directory node["jetty"]["webapp_dir"] do
  owner node["jetty"]["user"]
  mode "0755"
  recursive true
end

template "/etc/default/jetty" do
  source "default_jetty.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[jetty]"
end

template ::File.join(node["jetty"]["config_dir"], "jetty.xml") do
  source "jetty.xml.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[jetty]"
end
