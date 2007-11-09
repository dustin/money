class Category < ActiveRecord::Base
  belongs_to :group, :class_name => "Group", :foreign_key => "group_id"
end
