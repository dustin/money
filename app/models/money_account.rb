class MoneyAccount < ActiveRecord::Base
  belongs_to :group, :class_name => "MoneyGroup", :foreign_key => "money_group_id"
  has_many :transactions, :class_name => "MoneyTransaction"
end
