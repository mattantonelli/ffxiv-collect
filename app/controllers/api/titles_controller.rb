class Api::TitlesController < ApiController
  def index
    query = Title.includes(achievement: { category: :type }).all.ransack(@query)
    @titles = query.result.order('achievements.patch desc', order: :desc).limit(params[:limit])
  end

  def show
    @title = Title.find_by(id: params[:id])
    render_not_found unless @title.present?
  end
end
