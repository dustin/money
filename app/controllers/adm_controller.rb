class AdmController < ApplicationController

  TXN_LIMIT=TxnController::TXN_LIMIT

  def index
  end

  def users
    title "User List"
    @users=User.find :all, :order => 'login'
  end

  def reset_password
    title "Reset a user's password"
    if params[:user]
      @user=User.find_by_login params[:user]
      set_user_pw @user
      @user.save!
      title "Changed #{@user.login}'s password"
    else
      render :action => :reset_password_form
    end
  end

  def new_user
    title "Create a New User"
    @user=User.new params[:user]
    @groups = Group.find :all, :order => 'name'
    if request.post?
      set_user_pw @user
      @user.groups = Group.find params[:group].keys.map(&:to_i)
      @user.save!
      title "Created User #{@user.login}"
      render :action => :reset_password
    end
  end

  def set_groups
    title "Setting Groups for a User"
    @groups = Group.find :all, :order => 'name'
    if params[:user]
      @user=User.find_by_login params[:user]
      @user_gids=@user.groups.map(&:id)
    end
    if request.post?
      if @user.nil?
        flash[:error] = "No such user:  #{params[:user]}"
      else
        gids = []
        if params[:group]
          params[:group].each do |k,v|
            gids << k if v.to_i == 1
          end
        end
        @user.groups = gids.empty? ? [] : Group.find(gids)
        @user.save!
        title "Set Groups for #{@user.login}"
        render :action => :finished_set_groups
      end
    end
  end

  def recent
    @transactions=MoneyTransaction.find_with_deleted :all,
      :order => "id desc", :limit => TXN_LIMIT
    title "Recent Transactions"
  end

  def delete
    @txn = MoneyTransaction.find params[:id]
    @txn.destroy
  end

  def undelete
    @txn = MoneyTransaction.find_with_deleted params[:id]
    @txn.deleted_at = nil
    @txn.save!
  end

  protected

  def set_user_pw(user)
    user.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{user.login}--")
    @newpass = gen_pw
    user.password = @newpass
    user.password_confirmation = @newpass
  end

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
