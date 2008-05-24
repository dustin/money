class UsersController < ApplicationController
  # render new.rhtml
  def new
  end

  def edit
    title "Password change."
  end

  def update
    user = User.authenticate current_user.login, params[:user][:current_password]
    if user
      user.crypted_password = nil
      user.password = params[:user][:password]
      user.password_confirmation = params[:user][:password_confirmation]
      begin
        user.save!
        flash[:info] = 'Password changed.'
        redirect_to home_path
      rescue ActiveRecord::RecordInvalid => e
        flash[:error] = e.message
        redirect_to edit_user_path(current_user)
      end
    else
      flash[:error] = 'Incorrect old password.'
      redirect_to edit_user_path(current_user)
    end
  end

end
