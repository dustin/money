class MoneyGroup < ActiveRecord::Base
  set_primary_key "group_id"
  has_many :accounts, :class_name => "MoneyAccount", :foreign_key => "group_id"
  has_and_belongs_to_many :users, :class_name => "MoneyUser",
    :join_table => "money_group_xref", :foreign_key => "group_id",
    :association_foreign_key => "user_id"
end
