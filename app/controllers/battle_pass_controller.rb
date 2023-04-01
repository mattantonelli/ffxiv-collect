class BattlePassController < ApplicationController
  include Collection
  before_action :check_achievements!
  skip_before_action :set_owned!, :set_ids!, :set_dates!, :set_prices!

  def index
    if @character.present?
      @score = [@character.achievement_points, 25000].min
      @level = @score / 500
      @progress = @score % 500
    else
      @level = 0
    end

    mounts = Mount.tradeable.sample(5)
    minions = Minion.tradeable.sample(5)
    fashions = Fashion.tradeable.sample(5)
    orchestrions = Orchestrion.tradeable.where('length(name_en) < 20').sample(10)

    @rewards = (1..50).map do |level|
      if level % 2 != 0
        { image: view_context.image_tag('gil.png'), text: "#{view_context.number_with_delimiter(10000 * (level + 1))} Gil" }
      elsif level % 10 == 0
        mount = mounts.pop
        { image: view_context.sprite(mount, 'mounts-small'), text: mount.name }
      else
        digit = level.to_s[-1]
        case digit
        when '2', '6'
          { image: view_context.image_tag('orchestrion.png'), text: orchestrions.pop.name }
        when '4'
          minion = minions.pop
          { image: view_context.sprite(minion, 'minions-small'), text: minion.name }
        when '8'
          fashion = fashions.pop
          { image: view_context.sprite(fashion, 'fashions-small'), text: fashion.name }
        end
      end
    end
  end
end
