class MoneyRole < ActiveRecord::Base
  has_and_belongs_to_many :users, :class_name => "MoneyUser",
    :join_table => "money_user_roles_map"
end
