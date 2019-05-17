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

ActiveRecord::Schema.define(version: 2019_05_17_134131) do

  create_table "achievement_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.integer "type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_achievement_categories_on_name_de"
    t.index ["name_en"], name: "index_achievement_categories_on_name_en"
    t.index ["name_fr"], name: "index_achievement_categories_on_name_fr"
    t.index ["name_ja"], name: "index_achievement_categories_on_name_ja"
    t.index ["type_id"], name: "index_achievement_categories_on_type_id"
  end

  create_table "achievement_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_achievement_types_on_name_de"
    t.index ["name_en"], name: "index_achievement_types_on_name_en"
    t.index ["name_fr"], name: "index_achievement_types_on_name_fr"
    t.index ["name_ja"], name: "index_achievement_types_on_name_ja"
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
    t.string "title_en"
    t.string "title_de"
    t.string "title_fr"
    t.string "title_ja"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_id"
    t.string "item_name_en"
    t.string "item_name_de"
    t.string "item_name_fr"
    t.string "item_name_ja"
    t.integer "icon_id"
    t.index ["category_id"], name: "index_achievements_on_category_id"
    t.index ["name_de"], name: "index_achievements_on_name_de"
    t.index ["name_en"], name: "index_achievements_on_name_en"
    t.index ["name_fr"], name: "index_achievements_on_name_fr"
    t.index ["name_ja"], name: "index_achievements_on_name_ja"
    t.index ["order"], name: "index_achievements_on_order"
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
    t.index ["category_id"], name: "index_armoires_on_category_id"
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
    t.index ["name_de"], name: "index_bardings_on_name_de"
    t.index ["name_en"], name: "index_bardings_on_name_en"
    t.index ["name_fr"], name: "index_bardings_on_name_fr"
    t.index ["name_ja"], name: "index_bardings_on_name_ja"
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

  create_table "characters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "server", null: false
    t.string "portrait", null: false
    t.string "avatar", null: false
    t.datetime "last_parsed", null: false
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
    t.index ["category_id"], name: "index_emotes_on_category_id"
    t.index ["name_de"], name: "index_emotes_on_name_de"
    t.index ["name_en"], name: "index_emotes_on_name_en"
    t.index ["name_fr"], name: "index_emotes_on_name_fr"
    t.index ["name_ja"], name: "index_emotes_on_name_ja"
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
    t.index ["name_de"], name: "index_hairstyles_on_name_de"
    t.index ["name_en"], name: "index_hairstyles_on_name_en"
    t.index ["name_fr"], name: "index_hairstyles_on_name_fr"
    t.index ["name_ja"], name: "index_hairstyles_on_name_ja"
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
    t.index ["behavior_id"], name: "index_minions_on_behavior_id"
    t.index ["name_de"], name: "index_minions_on_name_de"
    t.index ["name_en"], name: "index_minions_on_name_en"
    t.index ["name_fr"], name: "index_minions_on_name_fr"
    t.index ["name_ja"], name: "index_minions_on_name_ja"
    t.index ["race_id"], name: "index_minions_on_race_id"
    t.index ["skill_type_id"], name: "index_minions_on_skill_type_id"
  end

  create_table "mounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.boolean "flying", null: false
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
    t.index ["name_de"], name: "index_orchestrion_categories_on_name_de"
    t.index ["name_en"], name: "index_orchestrion_categories_on_name_en"
    t.index ["name_fr"], name: "index_orchestrion_categories_on_name_fr"
    t.index ["name_ja"], name: "index_orchestrion_categories_on_name_ja"
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
    t.index ["category_id"], name: "index_orchestrions_on_category_id"
    t.index ["name_de"], name: "index_orchestrions_on_name_de"
    t.index ["name_en"], name: "index_orchestrions_on_name_en"
    t.index ["name_fr"], name: "index_orchestrions_on_name_fr"
    t.index ["name_ja"], name: "index_orchestrions_on_name_ja"
  end

  create_table "source_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_source_types_on_name"
  end

  create_table "sources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "collectable_id", null: false
    t.string "collectable_type", null: false
    t.string "text"
    t.integer "type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collectable_id", "collectable_type"], name: "index_sources_on_collectable_id_and_collectable_type"
    t.index ["type_id"], name: "index_sources_on_type_id"
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
    t.index ["character_id"], name: "index_users_on_character_id"
  end

end
