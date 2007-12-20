# == Schema Information
# Schema version: 8
#
# Table name: money_transactions
#
#  id               :integer       not null, primary key
#  user_id          :integer       not null
#  money_account_id :integer       not null
#  category_id      :integer       not null
#  descr            :string(255)   not null
#  amount           :decimal(6, 2) not null
#  ds               :date          not null
#  reconciled       :boolean       not null
#  deleted_at       :datetime      
#  ts               :datetime      not null
#

require 'cache_helpers'

class MoneyTransaction < ActiveRecord::Base

  acts_as_cached
  acts_as_paranoid

  # belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  # belongs_to :account, :class_name => "MoneyAccount", :foreign_key => "money_account_id"
  # belongs_to :category, :class_name => "Category", :foreign_key => "category_id"

  include CacheHelpers::UserCache
  include CacheHelpers::CategoryCache
  include CacheHelpers::AccountCache

end
