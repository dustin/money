class AllowanceTask < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  belongs_to :from_account, :class_name => "MoneyAccount", :foreign_key => "from_money_account_id"
  belongs_to :to_account, :class_name => "MoneyAccount", :foreign_key => "to_money_account_id"
  belongs_to :from_category, :class_name => "Category", :foreign_key => "from_category_id"
  belongs_to :to_category, :class_name => "Category", :foreign_key => "to_category_id"
end
