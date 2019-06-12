# == Schema Information
#
# Table name: versions
#
#  id               :bigint(8)        not null, primary key
#  item_type        :string(191)      not null
#  item_id          :bigint(8)        not null
#  collectable_type :string(191)
#  collectable_id   :bigint(8)
#  event            :string(255)      not null
#  whodunnit        :string(255)
#  object           :text(4294967295)
#  created_at       :datetime
#  object_changes   :text(4294967295)
#

module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern
    belongs_to :user, foreign_key: :whodunnit, required: false
  end
end
