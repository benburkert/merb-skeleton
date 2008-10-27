require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper')

given 'a new user' do
  @user = User.new
end

describe User do
  it 'should respond to .new' do
    User.should respond_to(:new)
  end

  describe '.new' do
    before do
      @response = User.new
    end

    it 'should return a User' do
      @response.should be_kind_of(User)
    end
  end

  [ :id, :name, :email, :openid_url ].each do |attribute|
    it "should respond_to ##{attribute}" do
      User.new.should respond_to(attribute)
    end

    describe "#{attribute}", :given => 'a new user' do
      before do
        @response = @user.send(attribute)
      end

      it 'should return nil by default' do
        @response.should be_nil
      end
    end
  end
end
