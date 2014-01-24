# Common packages
# Packages needed for the core OpenERP Server
%w{ python python-setuptools }.each do |pkg|
  package pkg do
    action :install
  end
end

# Common user
user "#{node[:openerp][:user]}" do
  comment "OpenERP System User"
  system true
  shell "/bin/false"
  home "/opt/openerp"
  manage_home true
end

# Common paths
directory "/var/log/openerp" do
  owner "#{node[:openerp][:user]}"
  group "root"
end
