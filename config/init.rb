# Go to http://wiki.merbivore.com/pages/init-rb

require 'config/dependencies.rb'

use_orm :datamapper
use_test :rspec
use_template_engine :haml

Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper

  # cookie session store configuration
  c[:session_secret_key]  = '74f67880b1a8fbc8301961c20b4612225636f085'  # required for cookie session store
  # c[:session_id_key] = '_session_id' # cookie session id key, defaults to "_session_id"

  c[:compass] = {
    :stylesheets          => 'app/stylesheets',
    :compiled_stylesheets => 'public/stylesheets/compiled'
  }

  # turn on asset bundling to ensure generated CSS is being compressed properly
  c[:bundle_assets] = true

  # add numeric query string to static assets allowing them to have a long cache ttl
  c[:reload_templates] = true
end

Merb::Plugins.config[:haml] = {
  :attr_wrapper => '"',
  :escape_html  => true,
}

Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end

Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.

  # functions to alter SASS output
  require Merb.root / 'lib' / 'sass-script-functions'

  # TODO: create Rack Middleware that performs the compression on the CSS/JS
  [ Merb::Assets::JavascriptAssetBundler, Merb::Assets::StylesheetAssetBundler ].each do |k|
    k.add_callback do |filename|
      Merb.logger.info "Compressing #{filename} with YUI Compressor"
      system("java -jar #{Merb.root / 'lib' / 'yui' / 'compressor.jar'} #{filename} -o #{filename} --charset utf-8 -v")
    end
  end
end
