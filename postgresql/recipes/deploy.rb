#
# Cookbook Name:: postgresql
# Recipe:: deploy
#
# Copyright 2013, HiganWorks LLC
#

include_recipe 'deploy'
node[:deploy].each do |application, deploy|
  node.set[:deploy][application][:database] = {
    :adapter => 'postgresql',
    :username => application,
    :password => node[:postgresql][:password],
    :database => "#{application}_#{deploy[:rails_env]}"
  }
end
