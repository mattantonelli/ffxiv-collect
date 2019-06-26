PaperTrail.config.has_paper_trail_defaults = {
  on: [:create, :update, :destroy],
  ignore: [:created_at, :updated_at]
}

PaperTrail.config.serializer = PaperTrail::Serializers::JSON
