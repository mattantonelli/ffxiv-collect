module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern
    belongs_to :user, foreign_key: :whodunnit, required: false
  end
end
