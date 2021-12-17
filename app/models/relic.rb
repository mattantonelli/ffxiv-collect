# == Schema Information
#
# Table name: relics
#
#  id         :bigint(8)        not null, primary key
#  name_en    :string(255)      not null
#  name_fr    :string(255)      not null
#  name_de    :string(255)      not null
#  name_ja    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Relic < ApplicationRecord
  has_many "character_#{name.pluralize}".to_sym
  has_many :characters, through: "character_#{name.pluralize}".to_sym
  translates :name

  def self.arr_relic_weapon_ids
    ids = [1675, 1746, 1816, 1885, 1955, 2052, 2140, 2213, 2214, 2306, 7888] + # Base
      (6257..6266).to_a + [9250] + # Zenith
      (7824..7833).to_a + [9251] + # Atma
      (7834..7843).to_a + [9252] + # Animus
      (7863..7872).to_a + [9253] + # Novus
      (8649..8658).to_a + [9254] + # Nexus
      (9491..9501).to_a + # Legendary
      (10054..10064).to_a # Zeta

    # Reorder the shields to follow the swords
    ids.each_slice(11).flat_map { |relics| relics.insert(1, relics.delete_at(9)) }.freeze
  end

  def self.eureka_physeos_weapon_ids
    (24707..24721).to_a.freeze
  end

  def self.deep_dungeon_weapon_ids
    ((15181..15193).to_a + [20456, 20457, 27347, 27348, 35756, 35774] + # Padjali
     (16152..16164).to_a + [20458, 20459, 27349, 27350, 35757, 35775] + # Kinna
     (22977..22991).to_a + [27379, 27380, 35759, 35777]).freeze # Empyrean
  end

  def self.manual_weapon_ids
    (Relic.arr_relic_weapon_ids + Relic.deep_dungeon_weapon_ids + Relic.eureka_physeos_weapon_ids).freeze
  end

  def self.lucis_tool_ids
    ([2327, 2354, 2379, 2404, 2429, 2455, 2480, 2506, 2532, 2558, 2584] + # Base
     (8436..8446).to_a + # Supra
     (10132..10142).to_a).freeze # Lucis
  end

  def self.skysteel_tool_ids
    ((29612..29644).to_a + # Skysteel -> Dragonsung
     (30282..30292).to_a + # Augmented Dragonsung
     (30293..30303).to_a + # Skysung
     (31714..31724).to_a).freeze # Skybuilders'
  end

  def self.resplendent_tool_ids
    ((33154..33161).to_a + # Resplendent DoH
     (33356..33358).to_a).freeze # Respldent DoL
  end

  def self.relic_tool_ids
    (Relic.lucis_tool_ids + Relic.skysteel_tool_ids + Relic.resplendent_tool_ids).freeze
  end

  def self.eureka_job_armor_ids
    ((22006..22080).to_a + # Base
     (22081..22155).to_a + # +1
     (22156..22230).to_a + # +2
     (22231..22305).to_a).freeze # Anemos
  end

  def self.eureka_elemental_armor_ids
    ((24087..24121).to_a + # Elemental
     (24723..24757).to_a + # +1
     (24758..24792).to_a).freeze # +2
  end

  def self.idealized_armor_ids
    (30142..30226).to_a.freeze
  end

  def self.bozjan_armor_ids
    (30715..30749).to_a + # Bozjan
    (31358..31392).to_a + # Augmented Bozjan
    (32723..32757).to_a + # Law's Order
    (32758..32792).to_a + # Augmented Law's Order
    (33613..33647).to_a.freeze # Blade's
  end

  def self.relic_armor_ids
    (Relic.eureka_job_armor_ids + Relic.eureka_elemental_armor_ids + Relic.idealized_armor_ids + Relic.bozjan_armor_ids).freeze
  end
end
