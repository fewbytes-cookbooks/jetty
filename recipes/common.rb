include_recipe "java"


major_ver = if node["jetty"]["version"].is_a? String
  node["jetty"]["version"].split(".").first
else
  node["jetty"]["version"]
end.to_i
template_name = if major_ver > 6 # xml config format and class names have changed when jetty moved to eclipse
  "jetty8.xml.erb"
else
  "jetty.xml.erb"
end

user node["jetty"]["user"] do
  home node["jetty"]["install_dir"]
end

%w(log_dir tmp_dir webapp_dir).each do |dir|
  directory node["jetty"][dir] do
    mode "0755"
    owner node["jetty"]["user"]
    recursive true
  end
end

directory node["jetty"]["config_dir"] do
  mode "0755"
end

directory node["jetty"]["context_dir"] do
  owner node["jetty"]["user"]
  mode "0755"
end

template "/etc/default/jetty" do
  source "default_jetty.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[jetty]"
end

template ::File.join(node["jetty"]["config_dir"], "jetty.xml") do
  source template_name
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[jetty]"
end
