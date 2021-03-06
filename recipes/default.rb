#
# Cookbook Name:: jetty
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

node.default["jetty"]["version"] = 6 # currently all the distros below are configured to use jetty 6.x packages.

case node["platform"]
when "centos","redhat","fedora"
  include_recipe "jpackage"
end

jetty_pkgs = value_for_platform(
  ["debian","ubuntu"] => {
    "default" => ["jetty","libjetty-extra"]
  },
  ["centos","redhat","fedora"] => {
    "default" => ["jetty6","jetty6-jsp-2.1","jetty6-management"]
  },
  "default" => ["jetty"]
)
jetty_pkgs.each do |pkg|
  package pkg do
    action :install
    options "-y" if node.platform_family? "debian"
  end
end

# we can't write config files prior to installing package because it makes apt-get unhappy.!
# We could pass --force-* to package managers but it requires testing and per distro code.!
# The crappy and order dependent (sigh) way is easier...
include_recipe "jetty::common"

service "jetty" do
  case node["platform"]
  when "centos","redhat","fedora"
    service_name "jetty6"
    supports :restart => true
  when "debian","ubuntu"
    service_name "jetty"
    supports :restart => true, :status => true
    action [:enable, :start]
  end
end

