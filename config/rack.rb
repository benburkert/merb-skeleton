require 'rack/cache'

# use HTTP caching
use Rack::Cache do
  import 'rack/cache/config/default'
  import 'rack/cache/config/no-cache'
  import 'rack/cache/config/busters'

  # log cache hit/miss/pass when in development mode
  set :verbose, Merb.environment == 'development'

  # override the default behavior to not cache when a cookie header is sent
  on :receive do
    pass! unless request.method? 'GET', 'HEAD'
    pass! if request.header? 'Authorization', 'Expect'
    lookup!
  end
end

# Compress output when in development mode
if Merb.environment == 'development'
  use Rack::Deflater
end

# use PathPrefix Middleware if :path_prefix is set in Merb::Config
if prefix = ::Merb::Config[:path_prefix]
  use Merb::Rack::PathPrefix, prefix
end

# comment this out if you are running merb behind a load balancer
# that serves static files
use Merb::Rack::Static, Merb.dir_for(:public)

# this is our main merb application
run Merb::Rack::Application.new
