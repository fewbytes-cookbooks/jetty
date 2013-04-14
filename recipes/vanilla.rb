#
# Cookbook Name:: jetty
# Recipe:: vanilla
#
# Copyright 2013, Fewbytes, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

node.default["jetty"]["home"] = node["jetty"]["install_dir"]

include_recipe "jetty::common"

directory node["jetty"]["install_dir"] do
  mode "0755"
end

bash "download and extract jetty" do
  code <<EOS
wget -O jetty.tar.gz #{node["jetty"]["tarball_url"]}
tar -xzf jetty.tar.gz -C #{node["jetty"]["install_dir"]} --strip-components=1
mv #{node["jetty"]["install_dir"]}/etc/* #{node["jetty"]["config_dir"]}/
rm -rf #{node["jetty"]["install_dir"]}/{etc,webapps,logs,contexts}
EOS
  creates ::File.join(node["jetty"]["install_dir"], "start.jar")
  cwd ENV["TMPDIR"]
end

{ "etc" => "config_dir", "logs" => "log_dir", "webapps" => "webapp_dir", "contexts" => "context_dir"}.each do |jetty_dir, dir_type|
  link ::File.join(node["jetty"]["install_dir"], jetty_dir) do
    to node["jetty"][dir_type]
  end
end

runit_service "jetty" do
  options :user => node["jetty"]["user"]
end
