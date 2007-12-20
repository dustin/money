# == Schema Information
# Schema version: 8
#
# Table name: categories
#
#  id       :integer       not null, primary key
#  group_id :integer       not null
#  name     :string(255)   not null
#  budget   :decimal(6, 2) 
#

class Category < ActiveRecord::Base
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
end
