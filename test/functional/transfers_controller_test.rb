require File.dirname(__FILE__) + '/../test_helper'

class TransfersControllerTest < ActionController::TestCase

  fixtures :users, :groups, :money_accounts, :categories, :money_transactions

  include TransfersHelper

  def test_transfer_helper
    oldbal=Group.find(1).balance
    txn1, txn2=do_transfer(User.find(1), MoneyAccount.find(1), MoneyAccount.find(2),
      Category.find(1), Category.find(1), '2007-11-01', 3.11, 'Transfer test')

    assert_in_delta -3.11, txn1.amount, 2 ** -20
    assert_in_delta 3.11, txn2.amount, 2 ** -20

    # The balance should not change since this is a transfer in-group
    assert_in_delta oldbal, Group.find(1).balance, 2 ** -20
  end

  def test_cross_group_transfer_through_helper
    oldbal=groups(:one).balance
    txn1, txn2=do_transfer(users(:quentin), money_accounts(:one), money_accounts(:three),
      categories(:one), categories(:three), '2007-11-01', 3.11, 'Transfer test')

    assert_in_delta -3.11, txn1.amount, 2 ** -20
    assert_in_delta 3.11, txn2.amount, 2 ** -20

    # The balance should not change since this is a transfer in-group
    assert_in_delta oldbal - 3.11, groups(:one).balance, 2 ** -20
  end

  def test_transfer_helper_zero
    assert_raise(RuntimeError) do
      do_transfer(User.find(1), MoneyAccount.find(1), MoneyAccount.find(2),
        Category.find(1), Category.find(1), '2007-11-01', 0, 'Transfer test')
    end
  end

  def test_transfer_helper_negative
    assert_raise(RuntimeError) do
      do_transfer(User.find(1), MoneyAccount.find(1), MoneyAccount.find(2),
        Category.find(1), Category.find(1), '2007-11-01', -1.43, 'Transfer test')
    end
  end

  def test_transfer_helper_same_cat
    assert_raise(RuntimeError) do
      do_transfer(User.find(1), MoneyAccount.find(1), MoneyAccount.find(1),
        Category.find(1), Category.find(1), '2007-11-01', 1.33, 'Transfer test')
    end
  end

  def test_transfer_form
    login_as :quentin
    get :new, {:acct_id => 1}
    assert_response :success
    assert assigns['today']
    assert assigns['current_acct']
    assert assigns['categories']
  end

  def test_transfer_bad_accounts
    login_as :quentin
    post :create, {:acct_id => 1, :dest_acct => 1}
    assert_response 302
    assert flash[:error]
  end

  def test_transfer
    login_as :quentin
    post :create, {:acct_id => 1, :dest_acct => 2, :dest_cat => 1,
      :src => {:category_id => 1},
      :details => {:ds => '2007-11-25', :amount => 1.33, :descr => 'test'}}
    assert_response 302
    assert flash[:info]
  end

  def test_transfer_across_groups
    login_as :quentin
    post :create, {:acct_id => 1, :dest_acct => 3, :dest_cat => 3,
      :src => {:category_id => 1},
      :details => {:ds => '2007-11-25', :amount => 1.33, :descr => 'test'}}
    assert_response 302
    assert flash[:info]
  end

end
