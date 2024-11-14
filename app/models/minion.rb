# == Schema Information
#
# Table name: minions
#
#  id                      :bigint(8)        not null, primary key
#  name_en                 :string(255)      not null
#  name_de                 :string(255)      not null
#  name_fr                 :string(255)      not null
#  name_ja                 :string(255)      not null
#  cost                    :integer          not null
#  attack                  :integer          not null
#  defense                 :integer          not null
#  hp                      :integer          not null
#  speed                   :integer          not null
#  area_attack             :boolean          not null
#  skill_angle             :integer          not null
#  arcana                  :boolean          not null
#  eye                     :boolean          not null
#  gate                    :boolean          not null
#  shield                  :boolean          not null
#  patch                   :string(255)
#  behavior_id             :integer          not null
#  race_id                 :integer          not null
#  skill_type_id           :integer
#  description_en          :string(1000)     not null
#  description_de          :string(1000)     not null
#  description_fr          :string(1000)     not null
#  description_ja          :string(1000)     not null
#  tooltip_en              :string(255)      not null
#  tooltip_de              :string(255)      not null
#  tooltip_fr              :string(255)      not null
#  tooltip_ja              :string(255)      not null
#  skill_en                :string(255)      not null
#  skill_de                :string(255)      not null
#  skill_fr                :string(255)      not null
#  skill_ja                :string(255)      not null
#  skill_description_en    :string(255)      not null
#  skill_description_de    :string(255)      not null
#  skill_description_fr    :string(255)      not null
#  skill_description_ja    :string(255)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  skill_cost              :integer          not null
#  enhanced_description_en :string(1000)     not null
#  enhanced_description_de :string(1000)     not null
#  enhanced_description_fr :string(1000)     not null
#  enhanced_description_ja :string(1000)     not null
#  item_id                 :integer
#  order                   :integer
#

class Minion < ApplicationRecord
  include Collectable
  translates :name, :description, :enhanced_description, :tooltip, :skill, :skill_description

  belongs_to :behavior, class_name: 'MinionBehavior'
  belongs_to :race, class_name: 'MinionRace'
  belongs_to :skill_type, class_name: 'MinionSkillType', optional: true

  scope :include_related, -> { include_sources.includes(:behavior, :race, :skill_type) }
  scope :ordered, -> { order(patch: :desc, order: :desc, id: :desc) }
  scope :summonable, -> { where.not(id: unsummonable_ids) }
  scope :verminion,  -> { where.not(id: variant_ids) }

  def strengths
    { 'Gates' => gate, 'Search Eyes' => eye, 'Shields' => shield, 'Arcana Stones' => arcana }
  end

  def variant?
    Minion.unsummonable_ids.include?(id)
  end

  def variants?
    Minion.variant_ids.include?(id)
  end

  def variants
    Minion.where(id: (id + 1)..(id + 3)) if variants?
  end

  def self.parent_id(id)
    variant_ids.find { |vid| id - 3 <= vid }
  end

  def self.angles
    [0, 30, 120, 360].freeze
  end

  def self.variant_ids
    [67, 71].freeze
  end

  def self.unsummonable_ids
    [68, 69, 70, 72, 73, 74].freeze
  end

  def self.available_filters
    %i(owned tradeable premium limited unknown)
  end

  def self.ransackable_attributes(auth_object = nil)
    super + %w(speed arcana eye gate shield race_id skill_type_id)
  end

  def self.ransackable_associations(auth_object = nil)
    super + %w(race skill_type)
  end
end
