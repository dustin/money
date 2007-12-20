require 'api_helper'

class CategoryStruct < ApiHelper::IdNameStruct
end

class AccountStruct < ApiHelper::IdNameStruct
end

class GroupStruct < ActionWebService::Struct
 member :id, :int
 member :name, :string
 member :categories, [CategoryStruct]
 member :accounts, [AccountStruct]
end

class AccountApi < ActionWebService::API::Base
 inflect_names false
 api_method :getAccountInfo,
  :expects => [:string, :string],
  :returns => [[GroupStruct]]
end
