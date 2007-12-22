# == Schema Information
# Schema version: 9
#
# Table name: money_transactions
#
#  id               :integer       not null, primary key
#  user_id          :integer       not null
#  money_account_id :integer       not null
#  category_id      :integer       not null
#  descr            :string(255)   not null
#  amount           :decimal(6, 2) not null
#  ds               :date          not null
#  reconciled       :boolean       not null
#  deleted_at       :datetime      
#  ts               :datetime      not null
#

class MoneyTransaction < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :account, :class_name => "MoneyAccount", :foreign_key => "money_account_id"
  belongs_to :category, :class_name => "Category", :foreign_key => "category_id"

  # acts_as_paranoid seems to break the count function.  Added a simple one.
  def self.count(*args)
    opts = args.extract_options!
    MoneyTransaction.find(:all, opts).length
  end

  def validate
    unless user.groups.include?(account.group)
      errors.add("user", "has no permission to account #{money_account_id}")
    end
    unless account.group_id == category.group_id
      errors.add("category", "#{category.id} does not belong to account #{account.id}")
    end
  end
end
