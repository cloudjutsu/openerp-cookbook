include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "database::postgresql"


postgresql_connection_info = {
  :host     => 'localhost',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

# Create a postgresql user but grant no privileges
postgresql_database_user node[:openerp][:user] do
  connection postgresql_connection_info
  password   node[:openerp][:password]
  role_options [ :createdb, :login ]
  action     :create
end

