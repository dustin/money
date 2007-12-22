# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie
  before_filter :login_required

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_money_session_id'

  def initialize
    @page_title='Money'
  end

  # Set the title for a given page.
  def title(str)
    @page_title=str
  end

  protected  

  def log_error(exception) 
    super(exception)

    begin
      ErrorMailer.deliver_snapshot(
        exception, 
        clean_backtrace(exception), 
        @session.instance_variable_get("@data"), 
        @params, 
        @request.env)
    rescue => e
      logger.error(e)
    end
  end

end
