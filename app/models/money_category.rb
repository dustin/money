class MoneyCategory < ActiveRecord::Base
  belongs_to :group, :class_name => "MoneyGroup", :foreign_key => "money_group_id"
end
