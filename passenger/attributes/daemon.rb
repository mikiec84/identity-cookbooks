cache_dir = node.fetch(:identity_shared_attributes).fetch(:cache_dir)

openssl_version = node.fetch(:identity_shared_attributes).fetch(:openssl_version)
openssl_srcpath = "#{cache_dir}/openssl-#{openssl_version}"

default[:passenger][:production][:path] = '/opt/nginx'
default[:passenger][:production][:native_support_dir] = node.fetch(:passenger).fetch(:production).fetch(:path) + '/passenger-native-support'

default[:passenger][:production][:configure_flags] = "--with-ipv6 --with-http_stub_status_module --with-http_ssl_module --with-http_realip_module --with-openssl=#{openssl_srcpath}"
default[:passenger][:production][:log_path] = '/var/log/nginx'

# Enable the status server on 127.0.0.1
default[:passenger][:production][:status_server] = true

default[:passenger][:production][:user] = node.fetch(:identity_shared_attributes).fetch(:production_user)
default[:passenger][:production][:version] = '5.3.7'

# Allow our local /16 to proxy setting X-Forwarded-For
# This is a little broad, but because we expect security group rules to prevent
# anyone except our trusted ALB from connecting anyway, we don't really care
# who is able to set X-Forwarded-For headers.
default[:passenger][:production][:realip_from_cidr] = node.fetch(:cloud).fetch('local_ipv4').split('.')[0..1].join('.') + '.0.0/16'

# Tune the following configurations for your environment. For more info see:
# https://www.phusionpassenger.com/library/config/nginx/optimization
default[:passenger][:production][:gzip] = true

# Nginx's default is 0, but we don't want that.
default[:passenger][:production][:keepalive_timeout] = '60 50'

default[:passenger][:production][:limit_connections] = true

# Keep max_pool_size and min_instances the same to create a fixed process pool
default[:passenger][:production][:max_pool_size] = node.fetch('cpu').fetch('total') * 2
default[:passenger][:production][:min_instances] = node.fetch('cpu').fetch('total') * 2

default[:passenger][:production][:max_instances_per_app] = 0
default[:passenger][:production][:pool_idle_time] = 0

# a list of URL's to pre-start.
default[:passenger][:production][:pre_start] = []

default[:passenger][:production][:sendfile] = true
default[:passenger][:production][:tcp_nopush] = false

# Set worker processes to number of CPU cores until benchmarking shows that we
# should do otherwise. See:
# http://nginx.org/en/docs/ngx_core_module.html#worker_processes
default[:passenger][:production][:worker_processes] = node.fetch('cpu').fetch('total')
default[:passenger][:production][:worker_connections] = 1024
