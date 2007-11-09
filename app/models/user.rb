class User < ActiveRecord::Base
  has_and_belongs_to_many :groups, :class_name => "Group",
    :join_table => "group_user_map"
  has_and_belongs_to_many :roles, :class_name => "Role",
    :join_table => "user_roles_map"
end
