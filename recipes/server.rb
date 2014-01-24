include_recipe "openerp::common"

# Packages needed for the core OpenERP Server
%w{ python-dateutil python-feedparser python-gdata python-ldap 
    python-libxslt1 python-lxml python-mako python-openid python-psycopg2 
    python-pybabel python-pychart python-pydot python-pyparsing python-reportlab 
    python-simplejson python-tz python-vatnumber python-vobject python-webdav 
    python-werkzeug python-xlwt python-yaml python-zsi python-unittest2 python-mock
    python-docutils python-jinja2 }.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "openerp" do
  path "#{Chef::Config['file_cache_path']}/openerp-#{node[:openerp][:version]}.tar.gz"
  source "http://nightly.openerp.com/7.0/nightly/src/openerp-#{node[:openerp][:version]}-latest.tar.gz"
  mode "0644"
end

bash "untar-openerp" do
  code <<-EOH
  tar zxf #{Chef::Config['file_cache_path']}/openerp-#{node[:openerp][:version]}.tar.gz -C #{node[:openerp][:dir]}
  chown -R openerp: #{node[:openerp][:dir]}/openerp-#{node[:openerp][:version]}*
  EOH
  not_if do 
    Dir[ "#{node[:openerp][:dir]}/openerp-#{node[:openerp][:version]}-*" ].length > 0
  end
end

ruby_block "link #{node[:openerp][:dir]}/server" do
  block do
    source= Dir[ "#{node[:openerp][:dir]}/openerp-#{node[:openerp][:version]}-*" ].sort.last
    File.symlink source, "#{node[:openerp][:dir]}/server" if ! File.symlink? "#{node[:openerp][:dir]}/server"
  end
end

template "/etc/openerp-server.conf" do
  source "openerp-server.conf.erb"
  owner "#{node[:openerp][:user]}"
  group "root"
  mode "0640"
  notifies :restart, "service[openerp-server]", :delayed
end

template "/etc/init.d/openerp-server" do
  source "openerp-server.sh.erb"
  mode "0755"
  notifies :restart, "service[openerp-server]", :delayed
end

service "openerp-server" do
  action :enable
  supports :start => true, :stop => true, :restart => true
end
