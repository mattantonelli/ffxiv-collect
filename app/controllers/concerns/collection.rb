module Collection
  extend ActiveSupport::Concern

  included do
    before_action :set_owned!, only: [:index, :type]
    before_action :set_ids!, on: :index
    before_action :set_dates!, on: :index
    before_action :set_prices!, on: :index
  end

  def ransack_with_patch_search
    search = params[:q] || { patch_eq: @patches.sort.last }

    # Hack the ransack params for searches that span multiple patches
    if search[:patch_eq] == 'all'
      # All achievements
      search.delete(:patch_eq)
    elsif search[:patch_eq].match?(/\A\d\z/)
      # Expansion search
      search[:patch_start] = search[:patch_eq]
      search.delete(:patch_eq)
    end

    search
  end

  def searchable_patches(legacy: false)
    patches = Achievement.pluck(:patch).compact.uniq
    patches.delete('1.0') unless legacy
    patches
  end

  def source_types(model)
    SourceType.joins(:sources).where('sources.collectable_type = ?', model)
      .with_filters(cookies).order("name_#{I18n.locale}").distinct
  end

  private
  def set_owned!
    key = controller_name.downcase

    @owned = {
      count: Redis.current.hgetall("#{key}-count"),
      percentage: Redis.current.hgetall(key)
    }
  end

  def set_ids!
    id_method = "#{controller_name.singularize}_ids"
    @collection_ids = @character&.send(id_method) || []
    @comparison_ids = @comparison&.send(id_method) || []
  end

  def set_dates!
    @dates = @character&.send("character_#{controller_name}")
      &.pluck("#{controller_name.singularize}_id", :created_at).to_h || {}
  end

  def set_prices!
    data_center = @character&.data_center&.downcase || 'primal'

    begin
      @prices = Redis.current.hgetall("prices-#{data_center}").each_with_object({}) do |(k, v), h|
        h[k.to_i] = JSON.parse(v)
      end
    rescue
      Rails.logger.error("There was a problem retrieving Universalis prices for #{data_center}")
      @prices = {}
    end
  end

  def check_achievements!
    return unless @character.present?

    if @character.achievements_count == -1
      link = view_context.link_to(t('alerts.here'), 'https://na.finalfantasyxiv.com/lodestone/my/setting/account/',
                                  target: '_blank')
      flash.now[:alert] = t('alerts.private_achievements', link: link)
    end
  end
end
