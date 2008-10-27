share_examples_for 'It is successful' do
  it 'should respond successfully' do
    @response.should be_successful
  end
end

share_examples_for 'It requires a user is logged in' do
  it 'should respond with a 401 Not Authorized status' do
    @response.status.should == 401
  end

  it_should_behave_like 'It displays the login page'
end

share_examples_for 'It received a request for an unknown resource' do
  it 'should respond with 404 Not Found status' do
    @response.status.should == 404
  end

  it 'should display the Not Found error page' do
    @response.body.should include('Not Found')
  end
end

share_examples_for 'It received an invalid request body' do
  it 'should respond with a 422 Unprocessable Entity status' do
    @response.status.should == 422
  end
end

share_examples_for 'It displays the new user page' do
  it 'should display the new user page' do
    @response.body.should include('Join')
  end
end

share_examples_for 'It displays the edit user page' do
  it 'should display the edit user page' do
    @response.body.should include('Edit User')
  end
end
