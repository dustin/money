module CacheHelpers

  module UserCache
    def user
      User.get_cache(user_id)
    end
  end

  module CategoryCache
    def category
      Category.get_cache(category_id)
    end
  end

  module AccountCache
    def account
      MoneyAccount.get_cache(money_account_id)
    end
  end

  module GroupCache
    def group
      Group.get_cache(group_id)
    end
  end
end