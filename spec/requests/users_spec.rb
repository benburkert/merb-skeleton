require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper')

describe 'resource(:users)' do
  before do
    @uri = resource(:users)
  end

  # TODO: uncomment once authz added, allow admin users access
  #describe 'GET', 'with no users' do
  #  before do
  #    @response = request(@uri)
  #  end
  #
  #  it_should_behave_like 'It is successful'
  #
  #  it 'should not display a list of users' do
  #    pending
  #    @response.should_not have_xpath('//table')
  #  end
  #end
  #
  #describe 'GET', 'when a user is logged in', :given => 'a user is logged in' do
  #  before do
  #    @response = request(@uri)
  #  end
  #
  #  it_should_behave_like 'It is successful'
  #
  #  it 'should display a list of users' do
  #    pending
  #    @response.should have_xpath('//table')
  #  end
  #end

  describe 'POST', 'with valid user information' do
    before do
      @response = request(@uri, :method => 'POST', :params => { :user => user_attributes })
    end

    it 'should redirect to resource(@user)' do
      @response.should redirect_to(resource(User.first), :message => { :success => 'Signup was successful', :notice => 'You are now logged in' })
    end

    it 'should log the user in automatically' do
      request(@response.headers['Location']).should be_successful
    end
  end

  describe 'POST', 'with invalid user information' do
    before do
      @response = request(@uri, :method => 'POST', :params => { :user => { :password => 'a', :password_confirmation => 'b' } })
    end

    it_should_behave_like 'It received an invalid request body'
    it_should_behave_like 'It displays the new user page'
  end
end

describe 'resource(:users, :new)' do
  describe 'GET' do
    before do
      @response = request(resource(:users, :new))
    end

    it_should_behave_like 'It is successful'
    it_should_behave_like 'It displays the new user page'
  end
end

describe 'resource(@user)', 'when a user is logged in', :given => 'a user is logged in' do
  before do
    @uri = resource(@user)
  end

  describe 'GET' do
    before do
      @response = request(@uri)
    end

    it_should_behave_like 'It is successful'
  end

  describe 'PUT', 'with valid user information' do
    before do
      @response = request(@uri, :method => 'PUT', :params => { :user => user_attributes.merge(:email => 'changed@example.com') })
    end

    it 'should redirect to resource(@user)' do
      @response.should redirect_to(@uri, :message => { :notice => 'User was successfully updated' })
    end
  end

  describe 'PUT', 'with invalid user information' do
    before do
      @response = request(@uri, :method => 'PUT', :params => { :user => { :password => 'a', :password_confirmation => 'b' } })
    end

    it_should_behave_like 'It received an invalid request body'
    it_should_behave_like 'It displays the edit user page'
  end

  describe 'DELETE' do
    before do
      @response = request(@uri, :method => 'DELETE')
    end

    it 'should redirect to the resource(:users)' do
      @response.should redirect_to(resource(:users))
    end
  end
end

describe 'resource(@user)', 'when a user is not logged in' do
  describe 'GET' do
    before do
      @user = create_user
      @response = request(resource(@user))
    end

    it_should_behave_like 'It requires a user is logged in'
  end
end

describe 'resource(@user, :edit)', 'when a user is logged in', :given => 'a user is logged in' do
  describe 'GET' do
    before do
      @response = request(resource(@user, :edit))
    end

    it_should_behave_like 'It is successful'
    it_should_behave_like 'It displays the edit user page'
  end
end

describe 'resource(@user, :edit)', 'when a user is not logged in' do
  describe 'GET' do
    before do
      @user = create_user
      @response = request(resource(@user, :edit))
    end

    it_should_behave_like 'It requires a user is logged in'
  end
end
