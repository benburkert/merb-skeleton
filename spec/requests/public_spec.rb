require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper')

describe 'GET url(:home)' do
  before do
    @response = request(url(:home))
  end

  it_should_behave_like 'It is successful'

  it 'should display the home page' do
    @response.body.should include('Home Page')
  end

  it 'should set the Last-Modified header' do
    @response.headers.should have_key('Last-Modified')
  end

  it 'should set the Expires header cache for 5 minutes' do
    @response.headers['Expires'].should == (@time_now + (5 * 60)).httpdate
  end

  it 'should set the Cache-Control to cache as public' do
    @response.headers['Cache-Control'].split(/\s*,\s*/).should include('public')
  end

  it 'should set the Cache-Control to cache for 5 minutes' do
    @response.headers['Cache-Control'].split(/\s*,\s*/).should include("max-age=#{5 * 60}")
  end
end

describe 'GET url(:home)', 'with non-HTML Accept header' do
  before do
    @response = request(url(:home), 'HTTP_ACCEPT' => 'application/xml')
  end

  it 'should respond with 406 Not Acceptable status' do
    @response.status.should == 406
  end

  it 'should display the Not Acceptable error page' do
    @response.body.should include('Not Acceptable')
  end
end

describe 'GET /not/found' do
  before do
    @response = request('/not/found')
  end

  it_should_behave_like 'It received a request for an unknown resource'
end

describe 'GET /bad/request-' do
  before do
    @response = request('/bad/request-')
  end

  it 'should respond with 400 Bad Request status' do
    @response.status.should == 400
  end

  it 'should display the Bad Request error page' do
    @response.body.should include('Bad Request')
  end
end
