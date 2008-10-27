require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper')

describe 'GET url(:login)' do
  before do
    @response = request(url(:login))
  end

  it_should_behave_like 'It is successful'
  it_should_behave_like 'It displays the login page'
end

describe 'PUT url(:perform_login)' do
  before do
    @user = create_user
    @response = login(@user.email, user_attributes[:password])
  end

  it 'should redirect to resource(@user)' do
    @response.should redirect_to(resource(@user))
  end
end

describe 'PUT url(:perform_login)', 'with an unknown user' do
  before do
    @response = login('unknown@example.com', '')
  end

  it_should_behave_like 'It requires a user is logged in'
end

describe 'DELETE url(:logout)', 'when a user is logged in', :given => 'a user is logged in' do
  before do
    @response = request(url(:logout), :method => 'DELETE')
  end

  it 'should redirect to url(:home)' do
    @response.should redirect_to(url(:home))
  end
end

describe 'GET url(:openid)', 'when a user is not logged in' do
  before do
    @response = request(url(:openid), :params => user_attributes.only(:openid_url))
  end

  it 'should redirect to OpenID provider' do
    # TODO: Test to make sure internet connection is available
    #@response.headers['Location'].should match(%r{\Ahttp://pip.verisignlabs.com/server\?})
  end
end

describe 'GET url(:openid)', 'when a user is logged in', :given => 'a user is logged in' do
  before do
    @response = request(url(:openid), :params => user_attributes.only(:openid_url))
  end

  it 'should redirect to resource(@user)' do
    @response.should redirect_to(resource(@user))
  end
end

describe 'GET url(:openid)', 'when a redirection from an OpenID provider', :given => 'a redirection from an OpenID provider' do
  before do
    @response = request(url(:openid), :params => @params, 'HTTP_COOKIE' => @cookie)
    @user = User.first
  end

  it 'should create a user' do
    @user.should_not be_nil
  end

  it 'should redirect to resource(@user)' do
    @response.should redirect_to(resource(@user), :message => { :notice => 'You are now logged in' })
  end
end

describe 'GET url(:openid)', 'when a redirection from an OpenID provider and an existing openid_url', :given => 'a redirection from an OpenID provider' do
  before do
    @user = create_user
    @response = request(url(:openid), :params => @params, 'HTTP_COOKIE' => @cookie)
  end

  it 'should redirect to resource(@user)' do
    @response.should redirect_to(resource(@user), :message => { :notice => 'You are now logged in' })
  end
end

describe 'GET url(:openid)', 'when a redirection from an OpenID provider and invalid user information', :given => 'a redirection from an OpenID provider' do
  before do
    @params['openid.sreg.email'] = ''
    @response = request(url(:openid), :params => @params, 'HTTP_COOKIE' => @cookie)
  end

  it_should_behave_like 'It requires a user is logged in'
end
