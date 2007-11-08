class MoneyTransaction < ActiveRecord::Base
  belongs_to :user, :class_name => "MoneyUser", :foreign_key => "money_user_id"
  belongs_to :account, :class_name => "MoneyAccount", :foreign_key => "money_account_id"
  belongs_to :cat, :class_name => "MoneyCategory", :foreign_key => "money_category_id"
end
