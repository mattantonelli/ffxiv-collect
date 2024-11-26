# == Schema Information
#
# Table name: groups
#
#  id          :bigint(8)        not null, primary key
#  slug        :string(255)      not null
#  name        :string(255)      not null
#  description :string(255)
#  public      :boolean          default(TRUE)
#  owner_id    :integer          not null
#  queued_at   :datetime         default(Thu, 01 Jan 1970 00:00:00.000000000 UTC +00:00)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Group < ApplicationRecord
  include Syncable
  extend FriendlyId
  friendly_id :random_slug, use: :slugged

  scope :ordered, -> { order(:name) }

  belongs_to :owner, class_name: 'User'
  has_many :group_memberships, dependent: :delete_all
  has_many :characters, through: :group_memberships

  validates_presence_of :slug, :name, :owner
  validates_length_of :name, :description, maximum: 255

  alias_method :members, :characters
  alias_attribute :formatted_name, :name

  def add_character(character)
    characters << character
  end

  def remove_character(character)
    characters.destroy(character)
  end

  def refresh
    update(queued_at: Time.now)
    GroupSyncJob.perform_later(id)
  end

  def valid_member?(user: nil, character: nil)
    (user.present? && owner_id == user.id) ||
      (character.present? && character.verified? && character_ids.include?(character.id))
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w(slug)
  end

  private
  def random_slug
    persisted? ? friendly_id : SecureRandom.hex(8)
  end
end
