# == Schema Information
# Schema version: 9
#
# Table name: allowance_tasks
#
#  id                    :integer       not null, primary key
#  name                  :string(64)    not null
#  description           :text          not null
#  creator_id            :integer       not null
#  owner_id              :integer       not null
#  frequency             :integer       not null
#  value                 :decimal(6, 2) not null
#  from_money_account_id :integer       not null
#  to_money_account_id   :integer       not null
#  from_category_id      :integer       not null
#  to_category_id        :integer       not null
#  deleted               :boolean       
#

class AllowanceTask < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  belongs_to :from_account, :class_name => "MoneyAccount", :foreign_key => "from_money_account_id"
  belongs_to :to_account, :class_name => "MoneyAccount", :foreign_key => "to_money_account_id"
  belongs_to :from_category, :class_name => "Category", :foreign_key => "from_category_id"
  belongs_to :to_category, :class_name => "Category", :foreign_key => "to_category_id"
end
