class AccountController < ApplicationController
  skip_before_filter :login_required

  def index
    if logged_in?
      redirect_to :controller => :acct, :action => :index
    else
      redirect_to :action => :login
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
      end

      flash[:notice] = "Logged in successfully"
      redirect_back_or_default :controller => :acct, :action => :index
    end
  end

  def change_password
    title "Password change."
    if request.post?
      user = User.authenticate current_user.login, params[:current_password]
      if user
        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]
        begin
          user.save!
          flash[:info] = 'Password changed.'
          redirect_to :controller => :acct, :action => :index
        rescue ActiveRecord::RecordInvalid => e
          flash[:error] = e.message
        end
      else
        flash[:error] = 'Incorrect old password.'
      end
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
