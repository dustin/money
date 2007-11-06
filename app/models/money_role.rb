class MoneyRole < ActiveRecord::Base
  set_primary_key "role_id"
  has_and_belongs_to_many :users, :class_name => "MoneyUser",
    :join_table => "money_user_role_map", :foreign_key => "role_id",
    :association_foreign_key => "user_id"
end
