class Api::OrchestrionsController < ApiController
  def index
    query = Orchestrion.all.ransack(@query)
    @orchestrions = query.result.available.include_related.ordered.distinct.limit(params[:limit])
  end

  def show
    @orchestrion = Orchestrion.find(params[:id])
  end
end
