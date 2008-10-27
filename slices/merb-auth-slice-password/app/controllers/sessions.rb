class MerbAuthSlicePassword::Sessions < MerbAuthSlicePassword::Application
  private

  def redirect_after_login
    message[:notice] = 'Successfully Logged in'
    redirect_back_or resource(session.user), :message => message, :ignore => [ slice_url(:login), slice_url(:logout) ]
  end

  def redirect_after_logout
    message[:notice] = 'Successfully Logged Out'
    redirect url(:home), :message => message
  end
end
