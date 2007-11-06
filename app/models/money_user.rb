class MoneyUser < ActiveRecord::Base
  set_primary_key "user_id"
  has_and_belongs_to_many :groups, :class_name => "MoneyGroup",
    :join_table => "money_group_xref", :foreign_key => "user_id",
    :association_foreign_key => "group_id"
  has_and_belongs_to_many :roles, :class_name => "MoneyRole",
    :join_table => "money_user_role_map", :foreign_key => "user_id",
    :association_foreign_key => "role_id"
end
