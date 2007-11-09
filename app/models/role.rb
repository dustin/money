class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :class_name => "User",
    :join_table => "user_roles_map"
end
