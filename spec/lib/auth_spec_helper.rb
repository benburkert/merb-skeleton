module AuthSpecHelper
  def user_attributes
    {
      :name                  => 'Test',
      :email                 => 'user@example.com',
      :password              => 'password',
      :password_confirmation => 'password',
      :openid_url            => 'http://dkubb.pip.verisignlabs.com/',  # TODO: register OpenID for merb-skeleton
     }
  end

  def create_user(attributes = {})
    User.create(user_attributes.update(attributes))
  end

  def login(email, password)
    request(url(:perform_login), :method => 'PUT', :params => { :email => email, :password => password })
  end
end
