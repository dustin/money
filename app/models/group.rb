class Group < ActiveRecord::Base
  has_many :accounts, :class_name => "Account"
  has_many :categories, :class_name => "Category"
  has_and_belongs_to_many :users, :class_name => "User",
    :join_table => "group_user_map"
end
