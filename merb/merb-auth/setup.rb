# This file is specifically setup for use with the merb-auth plugin.
# This file should be used to setup and configure your authentication stack.
# It is not required and may safely be deleted.
#
# To change the parameter names for the password or login field you may set either of these two options

Merb::Plugins.config[:'merb-auth'][:login_param]    = :email
Merb::Plugins.config[:'merb-auth'][:password_param] = :password

# Sets the default class for authentication.  This is primarily used for
# Plugins and the default strategies
Merb::Authentication.user_class = User

# Mixin the salted user mixin
require 'merb-auth-more/mixins/salted_user'
Merb::Authentication.user_class.class_eval{ include Merb::Authentication::Mixins::SaltedUser }

# Mixin the redirect back mixin
require 'merb-auth-more/mixins/redirect_back'

# Setup the session serialization
class Merb::Authentication

  def fetch_user(session_user_id)
    Merb::Authentication.user_class.get(session_user_id)
  end

  def store_user(user)
    user.nil? ? user : user.id
  end

end
