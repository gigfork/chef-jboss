#
# Cookbook Name:: jboss
# Recipe:: standalone_jdbc
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2012, Food and Agriculture Organization of the United Nations
#
# license Apache v2.0
#

jboss_home = node['jboss']['home']
jboss_user = node['jboss']['user']

include_recipe "maven"

datasources = populate_datasources

# create user
user node['jboss']['user']

ark 'jboss' do
  url  node['jboss']['url']
  checksum node['jboss']['checksum']
  home_dir node['jboss']['home']
  version node['jboss']['version']
  owner node['jboss']['user']
end

include_recipe "jboss::standalone_service_sysv"
include_recipe "jboss::extra_modules"

# only do it for standalone right now, not for standalone-full
if node['jboss']['manage_config_file']
  template jboss_config_file do
    source "#{node['jboss']['config']}.xml.erb"
    owner jboss_user
  end
end

# start service
service jboss_user do
  subscribes :restart, resources( :template => jboss_config_file), :immediately if node['jboss']['manage_config_file']
  action [ :enable, :start ]
end
