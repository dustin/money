module AdminControllerExtras

  protected

  def authorized?
    logged_in? && current_user.admin?
  end

  def access_denied
    if logged_in?
      # XXX:  Should probably find a good place for this document.
      render :template => 'report/access_denied'
    else
      redirect_to login_path
    end
  end

end