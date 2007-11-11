class MoneyTransaction < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :account, :class_name => "MoneyAccount", :foreign_key => "money_account_id"
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
end
