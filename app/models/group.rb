class Group < ActiveRecord::Base
  has_many :accounts, :class_name => "MoneyAccount"
  has_many :categories, :class_name => "Category"
  has_and_belongs_to_many :users, :class_name => "User",
    :join_table => "group_user_map"

  def balance
    accounts.map(&:balance).inject {|c, i| c + i}
  end
end
