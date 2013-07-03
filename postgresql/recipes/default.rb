#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2013, HiganWorks LLC
#

node.set[:postgresql][:password] = [OpenSSL::Random.random_bytes(24)].pack("m").chomp unless node[:postgresql][:password]

psql_command = "sudo -u postgres /usr/bin/psql"

node[:deploy].each do |application, deploy|
  execute "create new role for #{application}" do
    action :run
    command %Q{#{psql_command} -c "create user #{application} with password '#{node[:postgresql][:password]}';"}
  end

  execute "create new database owned by #{application} for #{application}" do
    action :run
    command %Q{#{psql_command} -c "create database #{application}_#{deploy['rails_env']} with password '#{node[:postgresql][:password]}';"}
  end
end
