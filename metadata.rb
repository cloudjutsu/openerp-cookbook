name             "openerp"
maintainer       "Adria Casajus"
maintainer_email "acasajus@cloudjutsu.com"
license          "Apache 2.0"
description      "OpenErp app stack"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "erp", "Prepares app stack for magento deployments"

%w{ debian ubuntu centos redhat fedora amazon }.each do |os|
  supports os
end

%w{ apt yum nginx postgresql database openssl }.each do |cb|
  depends cb
end
