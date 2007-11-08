class MoneyUser < ActiveRecord::Base
  has_and_belongs_to_many :groups, :class_name => "MoneyGroup",
    :join_table => "money_group_user_map"
  has_and_belongs_to_many :roles, :class_name => "MoneyRole",
    :join_table => "money_user_roles_map"
end
