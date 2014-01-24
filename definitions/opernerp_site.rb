define :openerp_site do

  include_recipe "nginx"

  directory "#{node[:nginx][:dir]}/ssl" do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  bash "Create SSL Certificates" do
    cwd "#{node[:nginx][:dir]}/ssl"
    code <<-EOH
    umask 022
    openssl genrsa 2048 > openerp.key
    openssl req -batch -new -x509 -days 365 -key openerp.key -out openerp.crt
    cat openerp.crt openerp.key > openerp.pem
    EOH
    only_if { !File.exists?("#{node[:nginx][:dir]}/ssl/openerp.pem") or File.zero?("#{node[:nginx][:dir]}/ssl/openerp.pem") }
  end

  bash "Drop default site" do
    cwd "#{node[:nginx][:dir]}"
    code <<-EOH
    rm -rf conf.d/default.conf
    rm -rf sites-enabled/default
    EOH
    notifies :reload, resources(:service => "nginx")
  end

  template "#{node[:nginx][:dir]}/sites-enabled/openerp" do
    source "nginx-site.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
      :path => "#{node[:openerp][:dir]}",
    })
  end

  nginx_site "openerp" do
    notifies :reload, resources(:service => "nginx")
  end

end
