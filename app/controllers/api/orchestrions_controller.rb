class Api::OrchestrionsController < ApiController
  def index
    query = Orchestrion.all.ransack(@query)
    @orchestrions = query.result.includes(:category).order(patch: :desc, order: :desc, id: :desc).limit(params[:limit])
  end

  def show
    @orchestrion = Orchestrion.find_by(id: params[:id])
    render_not_found unless @orchestrion.present?
  end
end
