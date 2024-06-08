# == Schema Information
#
# Table name: sources
#
#  id               :bigint(8)        not null, primary key
#  collectable_id   :integer          not null
#  collectable_type :string(255)      not null
#  text_en          :string(255)
#  type_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  related_id       :integer
#  related_type     :string(255)
#  premium          :boolean          default(FALSE)
#  limited          :boolean          default(FALSE)
#  text_de          :string(255)
#  text_fr          :string(255)
#  text_ja          :string(255)
#

class Source < ApplicationRecord
  belongs_to :collectable, polymorphic: true, touch: true
  belongs_to :related, polymorphic: true, required: false
  belongs_to :type, class_name: 'SourceType'

  before_save :assign_relations!

  has_paper_trail meta: { collectable_type: :collectable_type, collectable_id: :collectable_id }

  translates :text

  scope :exclude_premium, -> { where(premium: false) }
  scope :exclude_limited, -> { where(limited: false) }

  def self.treasure_hunts
    [' Map', 'Aquapolis', 'Uznair', 'Lyhe Ghiah', 'Excitatron', 'Gymnasion']
  end

  private
  def assign_relations!
    locale = nil

    %w(en de fr ja).each do |i18n|
      break locale = i18n if send("text_#{i18n}_changed?")
    end

    return unless locale.present?

    text = send("text_#{locale}")
    type = SourceType.find(type_id)

    case type.name_en
    when /(Achievement|Quest)/
      if relation = type.name_en.constantize.find_by("name_#{locale}" => text)
        set_text_for_relation!(relation)
        self.related_id = relation.id
        self.related_type = type.name_en
      else
        remove_relation!
      end
    when /(Dungeon|V&C Dungeon|Trial|Raid|Treasure Hunt)/
      if relation = Instance.find_by("name_#{locale}" => text)
        set_text_for_relation!(relation)
        self.related_id = relation.id
        self.related_type = 'Instance'
      else
        remove_relation!
      end
    when 'Event'
      self.limited = true

      if relation = Quest.find_by("name_#{locale}" => text)
        set_text_for_relation!(relation)
        self.related_id = relation.id
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

  def set_text_for_relation!(relation)
    %w(en de fr ja).each do |locale|
      self["text_#{locale}"] = relation["name_#{locale}"]
    end
  end
end
