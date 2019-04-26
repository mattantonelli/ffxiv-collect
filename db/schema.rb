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

ActiveRecord::Schema.define(version: 2019_04_26_130609) do

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
    t.index ["name_de"], name: "index_mounts_on_name_de"
    t.index ["name_en"], name: "index_mounts_on_name_en"
    t.index ["name_fr"], name: "index_mounts_on_name_fr"
    t.index ["name_ja"], name: "index_mounts_on_name_ja"
    t.index ["order"], name: "index_mounts_on_order"
    t.index ["patch"], name: "index_mounts_on_patch"
  end

end
