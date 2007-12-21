require 'account_api'
require 'transaction_api'
require 'api_helper'

class AccountService < ActionWebService::Base
  include ApiHelper

  web_service_api AccountApi

  def getAccountInfo(username, password)
    user=authenticate(username, password)
    user.groups
  end
end

class CatAcctMismatchException < StandardError
end

class TransactionService < ActionWebService::Base
  include ApiHelper

  web_service_api TransactionApi

  def addTransactions(username, password, txns)
    user=authenticate(username, password)

    MoneyTransaction.transaction do
      txns.each do |txn|
        cat=Category.find(txn.catid)
        acct=MoneyAccount.find(txn.acctid)

        unless user.groups.include?(acct.group)
          raise AuthorizationException.new("You have no permission to this account.")
        end
        if cat.group != acct.group
          raise CatAcctMismatchException.new("Cat doesn't belong to this group.")
        end

        t=MoneyTransaction.new :category => cat, :ds => txn.date,
          :amount => txn.amt, :descr => txn.descr,
          :money_account_id => acct.id, :ts => Time.now,
          :user_id => user.id
        t.save!
      end
    end

    0
  end
end

class ApiController < ApplicationController
  skip_before_filter :login_required, :login_from_cookie

  web_service_dispatching_mode :layered
  web_service :accountInfo, AccountService.new
  web_service :transaction, TransactionService.new
end
