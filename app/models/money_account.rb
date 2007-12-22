# == Schema Information
# Schema version: 9
#
# Table name: money_accounts
#
#  id       :integer       not null, primary key
#  group_id :integer       not null
#  name     :string(255)   not null
#  active   :boolean       
#

class MoneyAccount < ActiveRecord::Base
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  has_many :transactions, :class_name => "MoneyTransaction"

  def balance
    transactions.sum('amount') || 0
  end
end
