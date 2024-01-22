module Triad::PacksHelper
  def pack_cost(pack)
    pack.cost == 0 ? 'Tournament Reward' : "#{number_with_delimiter(pack.cost)} MGP"
  end
end
