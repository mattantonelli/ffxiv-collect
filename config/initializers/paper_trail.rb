PaperTrail.config.has_paper_trail_defaults = {
  on: [:create, :update, :destroy],
  ignore: [:created_at, :updated_at]
}

PaperTrail.config.serializer = PaperTrail::Serializers::JSON

# Adds a user association for easy reference
PaperTrail::Version.class_eval do
  belongs_to :user, foreign_key: :whodunnit, required: false
end
