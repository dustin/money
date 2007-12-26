class AdmController < ApplicationController

  def index
    # Show the form.
  end
  

  def reset_password
    user=User.find_by_login params[:user]
    user.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{user.login}--")
    @newpass = gen_pw
    user.password = @newpass
    user.password_confirmation = @newpass
    user.save!
  end

  protected

  def gen_pw
    # This is a dumb password generator, but it generates 8 lowercase letters.
    (1..8).map{|x| (97 + rand(26)).chr}.join
  end

  def authorized?
    current_user.admin?
  end

  def access_denied
    # XXX:  Should probably find a good place for this document.
    render :template => 'report/access_denied'
  end
end
