# == Schema Information
# Schema version: 8
#
# Table name: money_accounts
#
#  id       :integer       not null, primary key
#  group_id :integer       not null
#  name     :string(255)   not null
#

require 'cache_helpers'

class MoneyAccount < ActiveRecord::Base
  acts_as_cached

  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  has_many :transactions, :class_name => "MoneyTransaction"

  include CacheHelpers::GroupCache

  def balance
    transactions.sum('amount') || 0
  end
end
