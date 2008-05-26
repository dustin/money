# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def amt_class(amt)
    amt < 0 ? 'negative' : 'positive'
  end

  def currency_tag(amt, tag, opts={})
    classes = [amt_class(amt), opts.delete(:class)].reject{|x| x.nil?}
    content_tag tag, opts.merge(:class => classes * ' ') do
      number_to_currency(amt)
    end
  end

  # Singularize a word if the count is 1.
  def maybe_singular(cnt, word)
    cnt == 1 ? word.singularize : word
  end

  def txn_delete_tag(txn)
    link_to_remote(tag("img", {:src => '/images/trash.gif', :class => 'trash', :alt => '[delete]'}),
      :url => formatted_acct_txn_path(txn.account, txn, 'js'), :method => :delete)
  end
end
