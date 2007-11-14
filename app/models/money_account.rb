class MoneyAccount < ActiveRecord::Base
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
  has_many :transactions, :class_name => "MoneyTransaction"

  def balance
    transactions.sum('amount') || 0
  end
end
