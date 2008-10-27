class Users < Application
  # provides :xml, :yaml, :js

  before :ensure_authenticated, :exclude => [ :new, :create ]
  before :ensure_authorized,    :exclude => [ :new, :create ]

  # TODO: allow admin access in the future
  # def index
  #   @users = User.all
  #   display @users
  # end

  def new
    only_provides :html
    @user = User.new
    display @user
  end

  def create(user)
    @user = User.new(user)
    if @user.save
      session.user = @user
      redirect resource(@user), :message => { :success => 'Signup was successful', :notice => 'You are now logged in' }
    else
      message[:error] = 'There was an error while creating your user account'
      render :new, :status => 422
    end
  end

  def show(id)
    @user = get(id)
    display @user
  end

  def edit(id)
    only_provides :html
    @user = get(id)
    display @user
  end

  def update(id, user)
    @user = get(id)
    if @user.update_attributes(user)
      redirect resource(@user), :message => { :notice => 'Your user account was updated' }
    else
      message[:error] = 'There was an error while updating your user account'
      display @user, :edit, :status => 422
    end
  end

  def destroy(id)
    @user = get(id)
    @user.destroy
    redirect resource(:users)
  end

  private

  def get(id)
    User.get(id) || raise(NotFound)
  end

  def ensure_authorized
    case action_name
      # TODO: allow admin access in the future
      # when 'index'
      #   raise Forbidden
      when 'show', 'edit', 'update', 'destroy'
        raise Forbidden if session.user.id != params['id'].to_i
    end
  end
end
