::Chef::Node::Attribute.send(:include, Opscode::OpenSSL::Password)

default[:openerp][:version] = "7.0"
default[:openerp][:single_node] = "True"
default[:openerp][:user] = "openerp"
default[:openerp][:dir] = "/opt/openerp"
default[:openerp][:password] = "MEGALOLAZO"
