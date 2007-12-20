# == Schema Information
# Schema version: 8
#
# Table name: roles
#
#  id   :integer       not null, primary key
#  name :string(16)    not null
#

class Role < ActiveRecord::Base
  acts_as_cached

  has_and_belongs_to_many :users, :class_name => "User",
    :join_table => "user_roles_map"
end
