module P2wHelper
  def p2w_total(prices, counts)
    @prices.sum do |id, price|
      price * (counts[id] || 0)
    end
  end
end
