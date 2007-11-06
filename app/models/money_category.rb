class MoneyCategory < ActiveRecord::Base
  set_primary_key "cat_id"
  belongs_to :group, :class_name => "MoneyGroup", :foreign_key => "group_id"
end
