class AccountController < ApplicationController
  # say something nice, you goof!  something sweet.
  def index
    if logged_in? || User.count > 0
      redirect_to(:controller => '/acct', :action => 'index')
    else
      redirect_to(:action => 'login')
    end
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token,
          :expires => self.current_user.remember_token_expires_at }
        redirect_to :controller => '/acct', :action => 'index'
      end
      redirect_back_or_default(:controller => '/acct', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:controller => '/acct', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'login')
  end
end
