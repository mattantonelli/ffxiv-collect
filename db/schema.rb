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

ActiveRecord::Schema.define(version: 2019_04_28_185019) do

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

end
