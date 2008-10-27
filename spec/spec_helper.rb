require "rubygems"

# Add the local gems dir if found within the app root; any dependencies loaded
# hereafter will try to load from the local gems before loading system gems.
if (local_gem_dir = File.join(File.dirname(__FILE__), '..', 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

require "merb-core"
require "spec" # Satisfies Autotest and anyone else not using the Rake tasks

# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

# load the libraries
Dir[Merb.root / 'spec' / 'lib'    / '*.rb' ].each { |f| require f }

DataMapper.auto_migrate!

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
  config.include(AuthSpecHelper)

  config.before do
    @time_now = Time.now
    Time.stub!(:now).and_return(@time_now)
  end

  config.before do
    repository do |r|
      transaction = DataMapper::Transaction.new(r)
      transaction.begin
      r.adapter.push_transaction(transaction)
    end
  end

  config.after do
    repository do |r|
      adapter = r.adapter
      while adapter.current_transaction
        adapter.current_transaction.rollback
        adapter.pop_transaction
      end
    end
  end
end

# load the shared specs
Dir[Merb.root / 'spec' / 'shared' / '*.rb' ].each { |f| require f }

# in specs use in-memory storage for OpenID sessions
require 'openid/store/memory'

Merb::Authentication::Strategies::Basic::OpenID.class_eval do
  def openid_store
    ::OpenID::Store::Memory.new
  end
end
