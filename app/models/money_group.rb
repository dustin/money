class MoneyGroup < ActiveRecord::Base
  has_many :accounts, :class_name => "MoneyAccount"
  has_many :categories, :class_name => "MoneyCategory"
  has_and_belongs_to_many :users, :class_name => "MoneyUser",
    :join_table => "money_group_user_map"
end
