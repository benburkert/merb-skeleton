share_examples_for 'It displays the login page' do
  it 'should display the username and password login page' do
    @response.body.should include('Login')

    @response.body.should have_tag('form', :action => url(:perform_login)) { |nodes|
      nodes.first.should have_tag('input', :name => '_method', :value => 'put')
      nodes.first.should have_tag('input', :name => 'email')
      nodes.first.should have_tag('input', :name => 'password')
      nodes.first.should have_tag('input', :type => 'submit',  :value => 'Log In')
    }
  end

  it 'should display the OpenID login page' do
    @response.body.should include('Login')

    @response.body.should have_tag('form', :action => url(:openid)) { |nodes|
      nodes.first.should have_tag('input', :name => 'postLoginTargetURI', :value => url(:openid))
      nodes.first.should have_tag('input', :name => 'openid_url')
      nodes.first.should have_tag('input', :type => 'submit', :value => 'Log In')
    }
  end
end

# sets @user
given 'a user is logged in' do
  @user = create_user(:openid_url => nil)
  login(@user.email, user_attributes[:password])
end

# sets @cookie and @params
given 'a redirection from an OpenID provider' do
  # Unfortunately there's no way that I know of to test OpenID without
  # either mocking, setting up a separate OpenID server, or screen
  # scraping through a real provider.  Of all the available options
  # this was the simplest thing that could work.

  session = Merb::CookieSession.generate

  @cookie = "#{Merb::Config[:session_id_key]}=#{session.to_cookie}"

  @params = {
    'identity'             => 'http://dkubb.pip.verisignlabs.com/',
    'openid.mode'          => 'id_res',
    'openid.sreg.fullname' => user_attributes[:name],
    'openid.sreg.email'    => user_attributes[:email],
  }

  sreg_data = Hash.new { |h,k| h[k] = @params["openid.sreg.#{k}"] }

  openid_response = mock('OpenID::Consumer::SuccessResponse', :status => 'success', :identity_url => @params['identity'])
  sreg_response   = mock('OpenID::SReg::Response',            :data   => sreg_data)

  consumer = mock('OpenID::Consumer')
  consumer.should_receive(:complete).with(@params, 'http://example.org' + url(:openid)).and_return(openid_response)

  OpenID::SReg::Response.stub!(:from_success_response).and_return(sreg_response)
  OpenID::Consumer.stub!(:new).and_return(consumer)
end
