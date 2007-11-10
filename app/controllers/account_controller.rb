class AccountController < ApplicationController
  def list
    @groups = Group.find :all
    flash[:title] = 'Account List'
  end
end
