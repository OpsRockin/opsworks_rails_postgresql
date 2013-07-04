#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2013, HiganWorks LLC
#
node.set[:postgresql] = Mash.new unless node[:postgresql]


pg_pw = String.new
while pg_pw.length < 20
  pg_pw << OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
end


node.set[:postgresql][:password] = pg_pw unless node[:postgresql][:password]

Chef::Log.info JSON.pretty_generate(node)
psql_command = "sudo -u postgres /usr/bin/psql"

if node[:postgresql][:extentions]
  node[:postgresql][:extentions].each do |ext|
    execute "add extention #{ext} to template1" do
      action :run
      command %Q{#{psql_command} template1 -c "create extension #{ext};"}
      not_if do
        `#{psql_command} template1 -t -c 'select proname from pg_proc;'`.split.include?(ext)
      end
    end
  end
end

node[:deploy].each do |application, deploy|
  execute "create new role for #{application}" do
    action :run
    command %Q{#{psql_command} -c "create user #{application} with password '#{node[:postgresql][:password]}';"}
    not_if do
      `#{psql_command} -t -c 'select rolname from pg_roles;'`.split.include?(application)
    end
  end

  execute "create new database owned by #{application} for #{application}" do
    action :run
    command %Q{#{psql_command} -c "create database #{application}_#{deploy[:rails_env]} owner #{application};"}
    not_if do
      `#{psql_command} -t -c 'select datname from pg_database;'`.split.include?("#{application}_#{deploy[:rails_env]}")
    end
  end

end

service 'postgresql' do
  action :nothing
  supports :status => true, :restart => true, :reload => true
end

template '/etc/postgresql/9.1/main/pg_hba.conf' do
  source 'pg_hba.conf.erb'
  mode '0640'
  owner 'postgres'
  group 'postgres'
  action :create
  # notifies :reload, 'service[postgresql]', :immediately
  notifies :reload, resources(:service => 'postgresql'), :immediately
end
