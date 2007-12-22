class ReportController < ApplicationController

  def index
    title 'Reports'
  end

  def balances
    title 'Reports - Balances'
  end

  protected

  def authorized?
    current_user.admin?
  end

  def access_denied
    render :action => :access_denied
  end
end
