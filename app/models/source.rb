# == Schema Information
#
# Table name: sources
#
#  id               :bigint(8)        not null, primary key
#  collectable_id   :integer          not null
#  collectable_type :string(255)      not null
#  text             :string(255)
#  type_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  related_id       :integer
#  related_type     :string(255)
#  premium          :boolean          default(FALSE)
#  limited          :boolean          default(FALSE)
#

class Source < ApplicationRecord
  belongs_to :collectable, polymorphic: true, touch: true
  belongs_to :related, polymorphic: true, required: false
  belongs_to :type, class_name: 'SourceType'

  before_save :assign_relations!

  has_paper_trail meta: { collectable_type: :collectable_type, collectable_id: :collectable_id }

  scope :exclude_premium, -> { where(premium: false) }
  scope :exclude_limited, -> { where(limited: false) }

  def self.treasure_hunts
    [' Map', 'Aquapolis', 'Uznair', 'Lyhe Ghiah', 'Excitatron', 'Gymnasion']
  end

  private
  def assign_relations!
    type = SourceType.find(type_id)

    case type.name
    when /(Achievement|Quest)/
      relation = type.name.constantize.find_by(name_en: text)
      self.related_id = relation&.id
      self.related_type = type.name
    when /(Dungeon|Trial|Raid|Treasure Hunt)/
      if relation = Instance.find_by(name_en: text)
        self.related_id = relation.id
        self.related_type = 'Instance'
      end
    when 'Event'
      self.limited = true

      if quest = Quest.find_by(name_en: text)
        self.related_id = quest.id
        self.related_type = 'Quest'
      else
        remove_relation!
      end
    when 'Limited'
      self.limited = true
    when 'Premium'
      self.premium = true
    when 'Crafting'
    else
      remove_relation! if persisted?
    end
  end

  def remove_relation!
    self.related_id = nil
    self.related_type = nil
  end
end
