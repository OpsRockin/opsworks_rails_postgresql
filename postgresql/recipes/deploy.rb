#
# Cookbook Name:: postgresql
# Recipe:: deploy
#
# Copyright 2013, HiganWorks LLC
#

node[:deploy].each do |application, deploy|
  node.set[:deploy][application][:database] = {
    :adapter => 'postgresql',
    :username => application,
    :password => node[:postgresql][:password],
    :database => "#{application}_#{deploy[:rails_env]}"
  }
  node.set[:deploy][application][:migrate] = true
end
