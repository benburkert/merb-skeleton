module Merb
  module ExceptionsHelper
    def login_param
      Merb::Authentication::Strategies::Basic::Form.login_param
    end

    def password_param
      Merb::Authentication::Strategies::Basic::Form.password_param
    end
  end
end
