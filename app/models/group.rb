# == Schema Information
# Schema version: 9
#
# Table name: groups
#
#  id   :integer       not null, primary key
#  name :string(255)   not null
#

class Group < ActiveRecord::Base
  has_many :accounts, :class_name => "MoneyAccount"
  has_many :categories, :class_name => "Category"
  has_and_belongs_to_many :users, :class_name => "User",
    :join_table => "group_user_map"

  # Natural sort order is alphabetic
  def <=>(o)
    name <=> o.name
  end

  # This is a helper for the transfer page since
  # option_groups_from_collection_for_select doesn't seem to allow sorting
  def accounts_sorted
    accounts.sort
  end

  def balance
    accounts.map(&:balance).inject {|c, i| c + i}
  end
end
