# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_30_040915) do

  create_table "achievement_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.integer "type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.index ["name_de"], name: "index_achievement_categories_on_name_de"
    t.index ["name_en"], name: "index_achievement_categories_on_name_en"
    t.index ["name_fr"], name: "index_achievement_categories_on_name_fr"
    t.index ["name_ja"], name: "index_achievement_categories_on_name_ja"
    t.index ["order"], name: "index_achievement_categories_on_order"
    t.index ["type_id"], name: "index_achievement_categories_on_type_id"
  end

  create_table "achievement_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.index ["name_de"], name: "index_achievement_types_on_name_de"
    t.index ["name_en"], name: "index_achievement_types_on_name_en"
    t.index ["name_fr"], name: "index_achievement_types_on_name_fr"
    t.index ["name_ja"], name: "index_achievement_types_on_name_ja"
    t.index ["order"], name: "index_achievement_types_on_order"
  end

  create_table "achievements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "description_en", null: false
    t.string "description_de", null: false
    t.string "description_fr", null: false
    t.string "description_ja", null: false
    t.integer "points", null: false
    t.integer "order", null: false
    t.string "patch"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_id"
    t.integer "icon_id"
    t.index ["category_id"], name: "index_achievements_on_category_id"
    t.index ["name_de"], name: "index_achievements_on_name_de"
    t.index ["name_en"], name: "index_achievements_on_name_en"
    t.index ["name_fr"], name: "index_achievements_on_name_fr"
    t.index ["name_ja"], name: "index_achievements_on_name_ja"
    t.index ["order"], name: "index_achievements_on_order"
    t.index ["patch"], name: "index_achievements_on_patch"
  end

  create_table "armoire_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_armoire_categories_on_name_de"
    t.index ["name_en"], name: "index_armoire_categories_on_name_en"
    t.index ["name_fr"], name: "index_armoire_categories_on_name_fr"
    t.index ["name_ja"], name: "index_armoire_categories_on_name_ja"
    t.index ["order"], name: "index_armoire_categories_on_order"
  end

  create_table "armoires", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.integer "order", null: false
    t.string "patch"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.string "description_en"
    t.string "description_de"
    t.string "description_fr"
    t.string "description_ja"
    t.index ["category_id"], name: "index_armoires_on_category_id"
    t.index ["gender"], name: "index_armoires_on_gender"
    t.index ["name_de"], name: "index_armoires_on_name_de"
    t.index ["name_en"], name: "index_armoires_on_name_en"
    t.index ["name_fr"], name: "index_armoires_on_name_fr"
    t.index ["name_ja"], name: "index_armoires_on_name_ja"
    t.index ["order"], name: "index_armoires_on_order"
    t.index ["patch"], name: "index_armoires_on_patch"
  end

  create_table "bardings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "patch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_id"
    t.string "description_en"
    t.string "description_de"
    t.string "description_fr"
    t.string "description_ja"
    t.integer "order"
    t.index ["name_de"], name: "index_bardings_on_name_de"
    t.index ["name_en"], name: "index_bardings_on_name_en"
    t.index ["name_fr"], name: "index_bardings_on_name_fr"
    t.index ["name_ja"], name: "index_bardings_on_name_ja"
    t.index ["order"], name: "index_bardings_on_order"
    t.index ["patch"], name: "index_bardings_on_patch"
  end

  create_table "character_achievements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "achievement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_character_achievements_on_achievement_id"
    t.index ["character_id", "achievement_id"], name: "index_character_achievements_on_character_id_and_achievement_id", unique: true
    t.index ["character_id"], name: "index_character_achievements_on_character_id"
  end

  create_table "character_armoires", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "armoire_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["armoire_id"], name: "index_character_armoires_on_armoire_id"
    t.index ["character_id", "armoire_id"], name: "index_character_armoires_on_character_id_and_armoire_id", unique: true
    t.index ["character_id"], name: "index_character_armoires_on_character_id"
  end

  create_table "character_bardings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "barding_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barding_id"], name: "index_character_bardings_on_barding_id"
    t.index ["character_id", "barding_id"], name: "index_character_bardings_on_character_id_and_barding_id", unique: true
    t.index ["character_id"], name: "index_character_bardings_on_character_id"
  end

  create_table "character_emotes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "emote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "emote_id"], name: "index_character_emotes_on_character_id_and_emote_id", unique: true
    t.index ["character_id"], name: "index_character_emotes_on_character_id"
    t.index ["emote_id"], name: "index_character_emotes_on_emote_id"
  end

  create_table "character_fashions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "fashion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "fashion_id"], name: "index_character_fashions_on_character_id_and_fashion_id", unique: true
    t.index ["character_id"], name: "index_character_fashions_on_character_id"
    t.index ["fashion_id"], name: "index_character_fashions_on_fashion_id"
  end

  create_table "character_hairstyles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "hairstyle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "hairstyle_id"], name: "index_character_hairstyles_on_character_id_and_hairstyle_id", unique: true
    t.index ["character_id"], name: "index_character_hairstyles_on_character_id"
    t.index ["hairstyle_id"], name: "index_character_hairstyles_on_hairstyle_id"
  end

  create_table "character_minions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "minion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "minion_id"], name: "index_character_minions_on_character_id_and_minion_id", unique: true
    t.index ["character_id"], name: "index_character_minions_on_character_id"
    t.index ["minion_id"], name: "index_character_minions_on_minion_id"
  end

  create_table "character_mounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "mount_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "mount_id"], name: "index_character_mounts_on_character_id_and_mount_id", unique: true
    t.index ["character_id"], name: "index_character_mounts_on_character_id"
    t.index ["mount_id"], name: "index_character_mounts_on_mount_id"
  end

  create_table "character_orchestrions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "orchestrion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "orchestrion_id"], name: "index_character_orchestrions_on_character_id_and_orchestrion_id", unique: true
    t.index ["character_id"], name: "index_character_orchestrions_on_character_id"
    t.index ["orchestrion_id"], name: "index_character_orchestrions_on_orchestrion_id"
  end

  create_table "character_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "record_id"], name: "index_character_records_on_character_id_and_record_id", unique: true
    t.index ["character_id"], name: "index_character_records_on_character_id"
    t.index ["record_id"], name: "index_character_records_on_record_id"
  end

  create_table "character_relics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "relic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "relic_id"], name: "index_character_relics_on_character_id_and_relic_id", unique: true
    t.index ["character_id"], name: "index_character_relics_on_character_id"
    t.index ["relic_id"], name: "index_character_relics_on_relic_id"
  end

  create_table "character_spells", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "spell_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "spell_id"], name: "index_character_spells_on_character_id_and_spell_id", unique: true
    t.index ["character_id"], name: "index_character_spells_on_character_id"
    t.index ["spell_id"], name: "index_character_spells_on_spell_id"
  end

  create_table "characters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "server", null: false
    t.string "portrait", null: false
    t.string "avatar", null: false
    t.datetime "last_parsed"
    t.integer "verified_user_id"
    t.integer "achievements_count", default: 0
    t.integer "mounts_count", default: 0
    t.integer "minions_count", default: 0
    t.integer "orchestrions_count", default: 0
    t.integer "emotes_count", default: 0
    t.integer "bardings_count", default: 0
    t.integer "hairstyles_count", default: 0
    t.integer "armoires_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: true
    t.integer "achievement_points", default: 0
    t.string "free_company_id"
    t.datetime "refreshed_at", default: "1970-01-01 00:00:00"
    t.string "gender"
    t.integer "spells_count", default: 0
    t.integer "relics_count", default: 0
    t.datetime "queued_at", default: "1970-01-01 00:00:00"
    t.integer "fashions_count", default: 0
    t.integer "records_count", default: 0
    t.string "data_center"
    t.index ["achievement_points"], name: "index_characters_on_achievement_points"
    t.index ["achievements_count"], name: "index_characters_on_achievements_count"
    t.index ["armoires_count"], name: "index_characters_on_armoires_count"
    t.index ["bardings_count"], name: "index_characters_on_bardings_count"
    t.index ["data_center"], name: "index_characters_on_data_center"
    t.index ["emotes_count"], name: "index_characters_on_emotes_count"
    t.index ["fashions_count"], name: "index_characters_on_fashions_count"
    t.index ["free_company_id"], name: "index_characters_on_free_company_id"
    t.index ["hairstyles_count"], name: "index_characters_on_hairstyles_count"
    t.index ["minions_count"], name: "index_characters_on_minions_count"
    t.index ["mounts_count"], name: "index_characters_on_mounts_count"
    t.index ["orchestrions_count"], name: "index_characters_on_orchestrions_count"
    t.index ["records_count"], name: "index_characters_on_records_count"
    t.index ["relics_count"], name: "index_characters_on_relics_count"
    t.index ["spells_count"], name: "index_characters_on_spells_count"
  end

  create_table "emote_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_emote_categories_on_name_de"
    t.index ["name_en"], name: "index_emote_categories_on_name_en"
    t.index ["name_fr"], name: "index_emote_categories_on_name_fr"
    t.index ["name_ja"], name: "index_emote_categories_on_name_ja"
  end

  create_table "emotes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "patch"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_id"
    t.string "command_en"
    t.string "command_de"
    t.string "command_fr"
    t.string "command_ja"
    t.integer "order"
    t.index ["category_id"], name: "index_emotes_on_category_id"
    t.index ["name_de"], name: "index_emotes_on_name_de"
    t.index ["name_en"], name: "index_emotes_on_name_en"
    t.index ["name_fr"], name: "index_emotes_on_name_fr"
    t.index ["name_ja"], name: "index_emotes_on_name_ja"
    t.index ["order"], name: "index_emotes_on_order"
    t.index ["patch"], name: "index_emotes_on_patch"
  end

  create_table "fashions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "description_en", limit: 1000
    t.string "description_de", limit: 1000
    t.string "description_fr", limit: 1000
    t.string "description_ja", limit: 1000
    t.integer "order", null: false
    t.string "patch"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_fashions_on_name_de"
    t.index ["name_en"], name: "index_fashions_on_name_en"
    t.index ["name_fr"], name: "index_fashions_on_name_fr"
    t.index ["name_ja"], name: "index_fashions_on_name_ja"
    t.index ["order"], name: "index_fashions_on_order"
    t.index ["patch"], name: "index_fashions_on_patch"
  end

  create_table "free_companies", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hairstyles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "description_en", limit: 1000
    t.string "description_de", limit: 1000
    t.string "description_fr", limit: 1000
    t.string "description_ja", limit: 1000
    t.string "patch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_id"
    t.string "gender"
    t.index ["gender"], name: "index_hairstyles_on_gender"
    t.index ["name_de"], name: "index_hairstyles_on_name_de"
    t.index ["name_en"], name: "index_hairstyles_on_name_en"
    t.index ["name_fr"], name: "index_hairstyles_on_name_fr"
    t.index ["name_ja"], name: "index_hairstyles_on_name_ja"
    t.index ["patch"], name: "index_hairstyles_on_patch"
  end

  create_table "instances", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "content_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_type"], name: "index_instances_on_content_type"
    t.index ["name_en"], name: "index_instances_on_name_en"
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "description_en", limit: 1000, null: false
    t.string "description_de", limit: 1000, null: false
    t.string "description_fr", limit: 1000, null: false
    t.string "description_ja", limit: 1000, null: false
    t.string "icon_id", limit: 6
    t.boolean "tradeable"
    t.string "unlock_type"
    t.integer "unlock_id"
    t.string "crafter"
    t.integer "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price"
    t.string "plural_en"
    t.string "plural_de"
    t.string "plural_fr"
    t.string "plural_ja"
    t.integer "quest_id"
    t.index ["name_en"], name: "index_items_on_name_en"
    t.index ["quest_id"], name: "index_items_on_quest_id"
    t.index ["unlock_type"], name: "index_items_on_unlock_type"
  end

  create_table "minion_behaviors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minion_races", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minion_skill_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.integer "cost", null: false
    t.integer "attack", null: false
    t.integer "defense", null: false
    t.integer "hp", null: false
    t.integer "speed", null: false
    t.boolean "area_attack", null: false
    t.integer "skill_angle", null: false
    t.boolean "arcana", null: false
    t.boolean "eye", null: false
    t.boolean "gate", null: false
    t.boolean "shield", null: false
    t.string "patch"
    t.integer "behavior_id", null: false
    t.integer "race_id", null: false
    t.integer "skill_type_id"
    t.string "description_en", limit: 1000, null: false
    t.string "description_de", limit: 1000, null: false
    t.string "description_fr", limit: 1000, null: false
    t.string "description_ja", limit: 1000, null: false
    t.string "tooltip_en", null: false
    t.string "tooltip_de", null: false
    t.string "tooltip_fr", null: false
    t.string "tooltip_ja", null: false
    t.string "skill_en", null: false
    t.string "skill_de", null: false
    t.string "skill_fr", null: false
    t.string "skill_ja", null: false
    t.string "skill_description_en", null: false
    t.string "skill_description_de", null: false
    t.string "skill_description_fr", null: false
    t.string "skill_description_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "skill_cost", null: false
    t.string "enhanced_description_en", limit: 1000, null: false
    t.string "enhanced_description_de", limit: 1000, null: false
    t.string "enhanced_description_fr", limit: 1000, null: false
    t.string "enhanced_description_ja", limit: 1000, null: false
    t.integer "item_id"
    t.integer "order"
    t.index ["behavior_id"], name: "index_minions_on_behavior_id"
    t.index ["name_de"], name: "index_minions_on_name_de"
    t.index ["name_en"], name: "index_minions_on_name_en"
    t.index ["name_fr"], name: "index_minions_on_name_fr"
    t.index ["name_ja"], name: "index_minions_on_name_ja"
    t.index ["order"], name: "index_minions_on_order"
    t.index ["patch"], name: "index_minions_on_patch"
    t.index ["race_id"], name: "index_minions_on_race_id"
    t.index ["skill_type_id"], name: "index_minions_on_skill_type_id"
  end

  create_table "mounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.integer "order", null: false
    t.string "patch"
    t.string "description_en", null: false
    t.string "description_de", null: false
    t.string "description_fr", null: false
    t.string "description_ja", null: false
    t.string "enhanced_description_en", limit: 1000, null: false
    t.string "enhanced_description_de", limit: 1000, null: false
    t.string "enhanced_description_fr", limit: 1000, null: false
    t.string "enhanced_description_ja", limit: 1000, null: false
    t.string "tooltip_en", null: false
    t.string "tooltip_de", null: false
    t.string "tooltip_fr", null: false
    t.string "tooltip_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "movement", null: false
    t.integer "seats", null: false
    t.integer "item_id"
    t.string "video"
    t.integer "order_group"
    t.string "bgm_sample"
    t.index ["name_de"], name: "index_mounts_on_name_de"
    t.index ["name_en"], name: "index_mounts_on_name_en"
    t.index ["name_fr"], name: "index_mounts_on_name_fr"
    t.index ["name_ja"], name: "index_mounts_on_name_ja"
    t.index ["order"], name: "index_mounts_on_order"
    t.index ["patch"], name: "index_mounts_on_patch"
  end

  create_table "orchestrion_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.index ["name_de"], name: "index_orchestrion_categories_on_name_de"
    t.index ["name_en"], name: "index_orchestrion_categories_on_name_en"
    t.index ["name_fr"], name: "index_orchestrion_categories_on_name_fr"
    t.index ["name_ja"], name: "index_orchestrion_categories_on_name_ja"
    t.index ["order"], name: "index_orchestrion_categories_on_order"
  end

  create_table "orchestrions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "description_en", null: false
    t.string "description_de", null: false
    t.string "description_fr", null: false
    t.string "description_ja", null: false
    t.integer "order"
    t.string "patch"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_id"
    t.string "details"
    t.string "sample", null: false
    t.index ["category_id"], name: "index_orchestrions_on_category_id"
    t.index ["name_de"], name: "index_orchestrions_on_name_de"
    t.index ["name_en"], name: "index_orchestrions_on_name_en"
    t.index ["name_fr"], name: "index_orchestrions_on_name_fr"
    t.index ["name_ja"], name: "index_orchestrions_on_name_ja"
    t.index ["order"], name: "index_orchestrions_on_order"
    t.index ["patch"], name: "index_orchestrions_on_patch"
  end

  create_table "quests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en"
    t.string "name_de"
    t.string "name_fr"
    t.string "name_ja"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "event"
    t.index ["name_en"], name: "index_quests_on_name_en"
  end

  create_table "records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.text "description_en", null: false
    t.text "description_de", null: false
    t.text "description_fr", null: false
    t.text "description_ja", null: false
    t.integer "rarity", null: false
    t.string "patch"
    t.integer "linked_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.index ["linked_record_id"], name: "index_records_on_linked_record_id"
    t.index ["name_de"], name: "index_records_on_name_de"
    t.index ["name_en"], name: "index_records_on_name_en"
    t.index ["name_fr"], name: "index_records_on_name_fr"
    t.index ["name_ja"], name: "index_records_on_name_ja"
  end

  create_table "relics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_fr", null: false
    t.string "name_de", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "source_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_source_types_on_name", unique: true
  end

  create_table "sources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "collectable_id", null: false
    t.string "collectable_type", null: false
    t.string "text"
    t.integer "type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "related_id"
    t.string "related_type"
    t.boolean "premium", default: false
    t.boolean "limited", default: false
    t.index ["collectable_id", "collectable_type"], name: "index_sources_on_collectable_id_and_collectable_type"
    t.index ["limited"], name: "index_sources_on_limited"
    t.index ["premium"], name: "index_sources_on_premium"
    t.index ["related_id", "related_type"], name: "index_sources_on_related_id_and_related_type"
    t.index ["type_id"], name: "index_sources_on_type_id"
  end

  create_table "spell_aspects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en"
    t.string "name_de"
    t.string "name_fr"
    t.string "name_ja"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_spell_aspects_on_name_de"
    t.index ["name_en"], name: "index_spell_aspects_on_name_en"
    t.index ["name_fr"], name: "index_spell_aspects_on_name_fr"
    t.index ["name_ja"], name: "index_spell_aspects_on_name_ja"
  end

  create_table "spell_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en"
    t.string "name_de"
    t.string "name_fr"
    t.string "name_ja"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_spell_types_on_name_de"
    t.index ["name_en"], name: "index_spell_types_on_name_en"
    t.index ["name_fr"], name: "index_spell_types_on_name_fr"
    t.index ["name_ja"], name: "index_spell_types_on_name_ja"
  end

  create_table "spells", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "description_en", limit: 1000, null: false
    t.string "description_de", limit: 1000, null: false
    t.string "description_fr", limit: 1000, null: false
    t.string "description_ja", limit: 1000, null: false
    t.string "tooltip_en", limit: 1000, null: false
    t.string "tooltip_de", limit: 1000, null: false
    t.string "tooltip_fr", limit: 1000, null: false
    t.string "tooltip_ja", limit: 1000, null: false
    t.integer "order"
    t.integer "rank", null: false
    t.string "patch"
    t.integer "type_id", null: false
    t.integer "aspect_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aspect_id"], name: "index_spells_on_aspect_id"
    t.index ["name_de"], name: "index_spells_on_name_de"
    t.index ["name_en"], name: "index_spells_on_name_en"
    t.index ["name_fr"], name: "index_spells_on_name_fr"
    t.index ["name_ja"], name: "index_spells_on_name_ja"
    t.index ["order"], name: "index_spells_on_order"
    t.index ["type_id"], name: "index_spells_on_type_id"
  end

  create_table "titles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "female_name_en", null: false
    t.string "female_name_de", null: false
    t.string "female_name_fr", null: false
    t.string "female_name_ja", null: false
    t.integer "order", null: false
    t.integer "achievement_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_titles_on_achievement_id"
  end

  create_table "tomestone_rewards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "cost"
    t.integer "collectable_id"
    t.string "collectable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tomestone"
    t.index ["collectable_id", "collectable_type"], name: "index_tomestone_rewards_on_collectable_id_and_collectable_type"
    t.index ["tomestone"], name: "index_tomestone_rewards_on_tomestone"
  end

  create_table "user_characters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_user_characters_on_character_id"
    t.index ["user_id", "character_id"], name: "index_user_characters_on_user_id_and_character_id", unique: true
    t.index ["user_id"], name: "index_user_characters_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username"
    t.integer "discriminator"
    t.string "avatar_url"
    t.string "provider"
    t.string "uid"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "character_id"
    t.boolean "admin", default: false
    t.boolean "mod", default: false
    t.string "database", default: "garland", null: false
    t.index ["character_id"], name: "index_users_on_character_id"
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "collectable_type", limit: 191
    t.bigint "collectable_id"
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.text "object_changes", limit: 4294967295
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
