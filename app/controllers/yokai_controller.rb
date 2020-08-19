class YokaiController < ApplicationController
  include Collection
  before_action :check_achievements!
  skip_before_action :set_owned!, :set_ids!, :set_dates!

  def index
    @minions = Achievement.where('name_en like ?', 'Watch Me If You Can%').order(:order)
    @weapons = Achievement.where('name_en like ?', 'Otherworldly%').order(:order)
    @mounts = Mount.where(id: [87, 94, 228]).order(:order)

    @achievement_ids = @character&.achievement_ids || []
    @mount_ids = @character&.mount_ids || []
  end
end
