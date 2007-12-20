require 'api_helper'

class TransactionStruct < ActionWebService::Struct
 member :acctid, :int
 member :catid, :int
 member :amt, :float
 member :date, :date
 member :descr, :string
end

class TransactionApi < ActionWebService::API::Base
 inflect_names false
 api_method :addTransactions,
  :expects => [:string, :string, [TransactionStruct]],
  :returns => [:int]
end
