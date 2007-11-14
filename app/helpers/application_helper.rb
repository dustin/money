# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def amt_class(amt)
    rv='positive'
    if amt < 0
      rv='negative'
    end
    rv
  end

  def currency_span(amt)
    "<span class=\"#{amt_class(amt)}\">#{number_to_currency(amt)}</span>"
  end

end
