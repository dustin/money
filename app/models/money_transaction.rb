class MoneyTransaction < ActiveRecord::Base
  set_primary_key "transaction_id"
  belongs_to :user, :class_name => "MoneyUser", :foreign_key => "user_id"
  belongs_to :account, :class_name => "MoneyAccount", :foreign_key => "acct_id"
  belongs_to :cat, :class_name => "MoneyCategory", :foreign_key => "cat_id"
end
