# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_02_10_154102) do

  create_table "achievement_categories", charset: "utf8", force: :cascade do |t|
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

  create_table "achievement_types", charset: "utf8", force: :cascade do |t|
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

  create_table "achievements", charset: "utf8", force: :cascade do |t|
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

  create_table "armoire_categories", charset: "utf8", force: :cascade do |t|
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

  create_table "armoires", charset: "utf8", force: :cascade do |t|
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
    t.integer "item_id", null: false
    t.index ["category_id"], name: "index_armoires_on_category_id"
    t.index ["gender"], name: "index_armoires_on_gender"
    t.index ["item_id"], name: "index_armoires_on_item_id"
    t.index ["name_de"], name: "index_armoires_on_name_de"
    t.index ["name_en"], name: "index_armoires_on_name_en"
    t.index ["name_fr"], name: "index_armoires_on_name_fr"
    t.index ["name_ja"], name: "index_armoires_on_name_ja"
    t.index ["order"], name: "index_armoires_on_order"
    t.index ["patch"], name: "index_armoires_on_patch"
  end

  create_table "bardings", charset: "utf8", force: :cascade do |t|
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

  create_table "card_types", charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.index ["name_de"], name: "index_card_types_on_name_de", unique: true
    t.index ["name_en"], name: "index_card_types_on_name_en", unique: true
    t.index ["name_fr"], name: "index_card_types_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_card_types_on_name_ja", unique: true
  end

  create_table "cards", charset: "utf8", force: :cascade do |t|
    t.string "patch"
    t.integer "card_type_id", null: false
    t.integer "stars", null: false
    t.integer "top", null: false
    t.integer "right", null: false
    t.integer "bottom", null: false
    t.integer "left", null: false
    t.integer "buy_price"
    t.integer "sell_price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.text "description_en", null: false
    t.text "description_de", null: false
    t.text "description_fr", null: false
    t.text "description_ja", null: false
    t.integer "order_group"
    t.integer "deck_order"
    t.string "formatted_number", null: false
    t.index ["card_type_id"], name: "index_cards_on_card_type_id"
    t.index ["deck_order"], name: "index_cards_on_deck_order"
    t.index ["id", "patch"], name: "index_cards_on_id_and_patch"
    t.index ["name_de"], name: "index_cards_on_name_de"
    t.index ["name_en"], name: "index_cards_on_name_en"
    t.index ["name_fr"], name: "index_cards_on_name_fr"
    t.index ["name_ja"], name: "index_cards_on_name_ja"
    t.index ["order"], name: "index_cards_on_order"
    t.index ["order_group"], name: "index_cards_on_order_group"
    t.index ["stars"], name: "index_cards_on_stars"
  end

  create_table "character_achievements", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "achievement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_character_achievements_on_achievement_id"
    t.index ["character_id", "achievement_id"], name: "index_character_achievements_on_character_id_and_achievement_id", unique: true
    t.index ["character_id"], name: "index_character_achievements_on_character_id"
  end

  create_table "character_armoires", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "armoire_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["armoire_id"], name: "index_character_armoires_on_armoire_id"
    t.index ["character_id", "armoire_id"], name: "index_character_armoires_on_character_id_and_armoire_id", unique: true
    t.index ["character_id"], name: "index_character_armoires_on_character_id"
  end

  create_table "character_bardings", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "barding_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barding_id"], name: "index_character_bardings_on_barding_id"
    t.index ["character_id", "barding_id"], name: "index_character_bardings_on_character_id_and_barding_id", unique: true
    t.index ["character_id"], name: "index_character_bardings_on_character_id"
  end

  create_table "character_cards", charset: "utf8", force: :cascade do |t|
    t.integer "card_id"
    t.integer "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_character_cards_on_card_id"
    t.index ["character_id", "card_id"], name: "index_character_cards_on_character_id_and_card_id", unique: true
    t.index ["character_id"], name: "index_character_achievements_on_character_id"
  end

  create_table "character_emotes", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "emote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "emote_id"], name: "index_character_emotes_on_character_id_and_emote_id", unique: true
    t.index ["character_id"], name: "index_character_emotes_on_character_id"
    t.index ["emote_id"], name: "index_character_emotes_on_emote_id"
  end

  create_table "character_fashions", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "fashion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "fashion_id"], name: "index_character_fashions_on_character_id_and_fashion_id", unique: true
    t.index ["character_id"], name: "index_character_fashions_on_character_id"
    t.index ["fashion_id"], name: "index_character_fashions_on_fashion_id"
  end

  create_table "character_frames", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "frame_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id", "frame_id"], name: "character_id_and_frame_id", unique: true
    t.index ["character_id"], name: "index_character_frames_on_character_id"
    t.index ["frame_id"], name: "index_character_frames_on_frame_id"
  end

  create_table "character_hairstyles", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "hairstyle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "hairstyle_id"], name: "index_character_hairstyles_on_character_id_and_hairstyle_id", unique: true
    t.index ["character_id"], name: "index_character_hairstyles_on_character_id"
    t.index ["hairstyle_id"], name: "index_character_hairstyles_on_hairstyle_id"
  end

  create_table "character_leves", charset: "utf8", force: :cascade do |t|
    t.integer "leve_id"
    t.integer "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "leve_id"], name: "index_character_leves_on_character_id_and_leve_id", unique: true
    t.index ["character_id"], name: "index_character_achievements_on_character_id"
    t.index ["leve_id"], name: "index_character_leves_on_leve_id"
  end

  create_table "character_minions", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "minion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "minion_id"], name: "index_character_minions_on_character_id_and_minion_id", unique: true
    t.index ["character_id"], name: "index_character_minions_on_character_id"
    t.index ["minion_id"], name: "index_character_minions_on_minion_id"
  end

  create_table "character_mounts", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "mount_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "mount_id"], name: "index_character_mounts_on_character_id_and_mount_id", unique: true
    t.index ["character_id"], name: "index_character_mounts_on_character_id"
    t.index ["mount_id"], name: "index_character_mounts_on_mount_id"
  end

  create_table "character_npcs", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "npc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "npc_id"], name: "index_character_npcs_on_character_id_and_npc_id", unique: true
    t.index ["character_id"], name: "index_character_achievements_on_character_id"
    t.index ["npc_id"], name: "index_character_npcs_on_npc_id"
  end

  create_table "character_orchestrions", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "orchestrion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "orchestrion_id"], name: "index_character_orchestrions_on_character_id_and_orchestrion_id", unique: true
    t.index ["character_id"], name: "index_character_orchestrions_on_character_id"
    t.index ["orchestrion_id"], name: "index_character_orchestrions_on_orchestrion_id"
  end

  create_table "character_records", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "record_id"], name: "index_character_records_on_character_id_and_record_id", unique: true
    t.index ["character_id"], name: "index_character_records_on_character_id"
    t.index ["record_id"], name: "index_character_records_on_record_id"
  end

  create_table "character_relics", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "relic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "relic_id"], name: "index_character_relics_on_character_id_and_relic_id", unique: true
    t.index ["character_id"], name: "index_character_relics_on_character_id"
    t.index ["relic_id"], name: "index_character_relics_on_relic_id"
  end

  create_table "character_spells", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "spell_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "spell_id"], name: "index_character_spells_on_character_id_and_spell_id", unique: true
    t.index ["character_id"], name: "index_character_spells_on_character_id"
    t.index ["spell_id"], name: "index_character_spells_on_spell_id"
  end

  create_table "character_survey_records", charset: "utf8", force: :cascade do |t|
    t.integer "character_id"
    t.integer "survey_record_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id", "survey_record_id"], name: "character_id_and_survey_record_id", unique: true
    t.index ["character_id"], name: "index_character_survey_records_on_character_id"
    t.index ["survey_record_id"], name: "index_character_survey_records_on_survey_record_id"
  end

  create_table "characters", charset: "utf8", force: :cascade do |t|
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
    t.integer "ranked_achievement_points", default: 0
    t.integer "ranked_mounts_count", default: 0
    t.integer "ranked_minions_count", default: 0
    t.datetime "last_ranked_achievement_time"
    t.integer "survey_records_count", default: 0
    t.integer "frames_count", default: 0
    t.boolean "banned", default: false
    t.integer "cards_count", default: 0
    t.integer "npcs_count", default: 0
    t.integer "leves_count", default: 0
    t.index ["achievement_points"], name: "index_characters_on_achievement_points"
    t.index ["achievements_count"], name: "index_characters_on_achievements_count"
    t.index ["armoires_count"], name: "index_characters_on_armoires_count"
    t.index ["bardings_count"], name: "index_characters_on_bardings_count"
    t.index ["cards_count"], name: "index_characters_on_cards_count"
    t.index ["data_center"], name: "index_characters_on_data_center"
    t.index ["emotes_count"], name: "index_characters_on_emotes_count"
    t.index ["fashions_count"], name: "index_characters_on_fashions_count"
    t.index ["frames_count"], name: "index_characters_on_frames_count"
    t.index ["free_company_id"], name: "index_characters_on_free_company_id"
    t.index ["hairstyles_count"], name: "index_characters_on_hairstyles_count"
    t.index ["last_ranked_achievement_time"], name: "index_characters_on_last_ranked_achievement_time"
    t.index ["leves_count"], name: "index_characters_on_leves_count"
    t.index ["minions_count"], name: "index_characters_on_minions_count"
    t.index ["mounts_count"], name: "index_characters_on_mounts_count"
    t.index ["name"], name: "index_characters_on_name"
    t.index ["npcs_count"], name: "index_characters_on_npcs_count"
    t.index ["orchestrions_count"], name: "index_characters_on_orchestrions_count"
    t.index ["public"], name: "index_characters_on_public"
    t.index ["ranked_achievement_points"], name: "index_characters_on_ranked_achievement_points"
    t.index ["ranked_minions_count"], name: "index_characters_on_ranked_minions_count"
    t.index ["ranked_mounts_count"], name: "index_characters_on_ranked_mounts_count"
    t.index ["records_count"], name: "index_characters_on_records_count"
    t.index ["relics_count"], name: "index_characters_on_relics_count"
    t.index ["server"], name: "index_characters_on_server"
    t.index ["spells_count"], name: "index_characters_on_spells_count"
    t.index ["survey_records_count"], name: "index_characters_on_survey_records_count"
    t.index ["updated_at"], name: "index_characters_on_updated_at"
  end

  create_table "deck_cards", charset: "utf8", force: :cascade do |t|
    t.integer "deck_id"
    t.integer "card_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_deck_cards_on_card_id"
    t.index ["deck_id"], name: "index_deck_cards_on_deck_id"
  end

  create_table "decks", charset: "utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "rule_id"
    t.integer "npc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rating"
    t.string "notes", limit: 1000
    t.boolean "updated", default: true
    t.string "user_uid"
    t.index ["npc_id"], name: "index_decks_on_npc_id"
    t.index ["rule_id"], name: "index_decks_on_rule_id"
    t.index ["updated"], name: "index_decks_on_updated"
    t.index ["user_id"], name: "index_decks_on_user_id"
    t.index ["user_uid"], name: "index_decks_on_user_uid"
  end

  create_table "emote_categories", charset: "utf8", force: :cascade do |t|
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

  create_table "emotes", charset: "utf8", force: :cascade do |t|
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

  create_table "fashions", charset: "utf8", force: :cascade do |t|
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

  create_table "frames", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "patch"
    t.integer "item_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order"
    t.index ["item_id"], name: "index_frames_on_item_id"
    t.index ["name_de"], name: "index_frames_on_name_de"
    t.index ["name_en"], name: "index_frames_on_name_en"
    t.index ["name_fr"], name: "index_frames_on_name_fr"
    t.index ["name_ja"], name: "index_frames_on_name_ja"
    t.index ["order"], name: "index_frames_on_order"
    t.index ["patch"], name: "index_frames_on_patch"
  end

  create_table "free_companies", id: :string, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "queued_at", default: "1970-01-01 00:00:00"
  end

  create_table "group_memberships", charset: "utf8", force: :cascade do |t|
    t.integer "group_id"
    t.integer "character_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_group_memberships_on_character_id"
    t.index ["group_id", "character_id"], name: "index_group_memberships_on_group_id_and_character_id", unique: true
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
  end

  create_table "groups", charset: "utf8", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.string "description"
    t.boolean "public", default: true
    t.integer "owner_id", null: false
    t.datetime "queued_at", default: "1970-01-01 00:00:00"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_groups_on_owner_id"
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "hairstyles", charset: "utf8", force: :cascade do |t|
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
    t.boolean "vierable", default: false
    t.integer "image_count", default: 0
    t.boolean "hrothable", default: false
    t.index ["gender"], name: "index_hairstyles_on_gender"
    t.index ["name_de"], name: "index_hairstyles_on_name_de"
    t.index ["name_en"], name: "index_hairstyles_on_name_en"
    t.index ["name_fr"], name: "index_hairstyles_on_name_fr"
    t.index ["name_ja"], name: "index_hairstyles_on_name_ja"
    t.index ["patch"], name: "index_hairstyles_on_patch"
  end

  create_table "instances", charset: "utf8", force: :cascade do |t|
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

  create_table "items", charset: "utf8", force: :cascade do |t|
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

  create_table "leve_categories", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "craft_en", null: false
    t.string "craft_de", null: false
    t.string "craft_fr", null: false
    t.string "craft_ja", null: false
    t.integer "order", null: false
    t.boolean "items", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["craft_de"], name: "index_leve_categories_on_craft_de"
    t.index ["craft_en"], name: "index_leve_categories_on_craft_en"
    t.index ["craft_fr"], name: "index_leve_categories_on_craft_fr"
    t.index ["craft_ja"], name: "index_leve_categories_on_craft_ja"
    t.index ["name_de"], name: "index_leve_categories_on_name_de"
    t.index ["name_en"], name: "index_leve_categories_on_name_en"
    t.index ["name_fr"], name: "index_leve_categories_on_name_fr"
    t.index ["name_ja"], name: "index_leve_categories_on_name_ja"
    t.index ["order"], name: "index_leve_categories_on_order"
  end

  create_table "leves", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.integer "category_id", null: false
    t.integer "level", null: false
    t.integer "location_id", null: false
    t.string "issuer_name_en", null: false
    t.string "issuer_name_de", null: false
    t.string "issuer_name_fr", null: false
    t.string "issuer_name_ja", null: false
    t.decimal "issuer_x", precision: 3, scale: 1, null: false
    t.decimal "issuer_y", precision: 3, scale: 1, null: false
    t.integer "item_id"
    t.integer "item_quantity"
    t.string "patch"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_leves_on_category_id"
    t.index ["item_id"], name: "index_leves_on_item_id"
    t.index ["location_id"], name: "index_leves_on_location_id"
    t.index ["name_de"], name: "index_leves_on_name_de"
    t.index ["name_en"], name: "index_leves_on_name_en"
    t.index ["name_fr"], name: "index_leves_on_name_fr"
    t.index ["name_ja"], name: "index_leves_on_name_ja"
    t.index ["patch"], name: "index_leves_on_patch"
  end

  create_table "locations", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "region_en", null: false
    t.string "region_de", null: false
    t.string "region_fr", null: false
    t.string "region_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_locations_on_name_de", unique: true
    t.index ["name_en"], name: "index_locations_on_name_en", unique: true
    t.index ["name_fr"], name: "index_locations_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_locations_on_name_ja", unique: true
    t.index ["region_de"], name: "index_locations_on_region_de"
    t.index ["region_en"], name: "index_locations_on_region_en"
    t.index ["region_fr"], name: "index_locations_on_region_fr"
    t.index ["region_ja"], name: "index_locations_on_region_ja"
  end

  create_table "minion_behaviors", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minion_races", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minion_skill_types", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minions", charset: "utf8", force: :cascade do |t|
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

  create_table "mounts", charset: "utf8", force: :cascade do |t|
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

  create_table "npc_cards", charset: "utf8", force: :cascade do |t|
    t.integer "npc_id", null: false
    t.integer "card_id", null: false
    t.boolean "fixed", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_npc_cards_on_card_id"
    t.index ["npc_id"], name: "index_npc_cards_on_npc_id"
  end

  create_table "npc_rewards", charset: "utf8", force: :cascade do |t|
    t.integer "npc_id", null: false
    t.integer "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_npc_rewards_on_card_id"
    t.index ["npc_id"], name: "index_npc_rewards_on_npc_id"
  end

  create_table "npcs", charset: "utf8", force: :cascade do |t|
    t.decimal "x", precision: 3, scale: 1
    t.decimal "y", precision: 3, scale: 1
    t.integer "resident_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quest_id"
    t.string "patch"
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.integer "location_id", null: false
    t.decimal "difficulty", precision: 3, scale: 2
    t.boolean "excluded", default: false
    t.index ["location_id"], name: "index_npcs_on_location_id"
    t.index ["name_de"], name: "index_npcs_on_name_de", unique: true
    t.index ["name_en"], name: "index_npcs_on_name_en", unique: true
    t.index ["name_fr"], name: "index_npcs_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_npcs_on_name_ja", unique: true
    t.index ["patch"], name: "index_npcs_on_patch"
  end

  create_table "npcs_rules", charset: "utf8", force: :cascade do |t|
    t.integer "npc_id"
    t.integer "rule_id"
    t.index ["npc_id", "rule_id"], name: "index_npcs_rules_on_npc_id_and_rule_id", unique: true
    t.index ["npc_id"], name: "index_npcs_rules_on_npc_id"
    t.index ["rule_id"], name: "index_npcs_rules_on_rule_id"
  end

  create_table "orchestrion_categories", charset: "utf8", force: :cascade do |t|
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

  create_table "orchestrions", charset: "utf8", force: :cascade do |t|
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

  create_table "pack_cards", charset: "utf8", force: :cascade do |t|
    t.integer "pack_id", null: false
    t.integer "card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_pack_cards_on_card_id"
    t.index ["pack_id"], name: "index_pack_cards_on_pack_id"
  end

  create_table "packs", charset: "utf8", force: :cascade do |t|
    t.integer "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.index ["name_de"], name: "index_packs_on_name_de", unique: true
    t.index ["name_en"], name: "index_packs_on_name_en", unique: true
    t.index ["name_fr"], name: "index_packs_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_packs_on_name_ja", unique: true
  end

  create_table "quests", charset: "utf8", force: :cascade do |t|
    t.string "name_en"
    t.string "name_de"
    t.string "name_fr"
    t.string "name_ja"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "event"
    t.index ["name_en"], name: "index_quests_on_name_en"
  end

  create_table "records", charset: "utf8", force: :cascade do |t|
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

  create_table "relic_types", charset: "utf8", force: :cascade do |t|
    t.string "name_en"
    t.string "name_de"
    t.string "name_fr"
    t.string "name_ja"
    t.string "category"
    t.integer "jobs"
    t.integer "order"
    t.integer "expansion"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expansion"], name: "index_relic_types_on_expansion"
    t.index ["order"], name: "index_relic_types_on_order"
  end

  create_table "relics", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_fr", null: false
    t.string "name_de", null: false
    t.string "name_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.integer "type_id"
    t.integer "achievement_id"
    t.index ["achievement_id"], name: "index_relics_on_achievement_id"
    t.index ["order"], name: "index_relics_on_order"
    t.index ["type_id"], name: "index_relics_on_type_id"
  end

  create_table "rules", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_de", null: false
    t.string "name_fr", null: false
    t.string "name_ja", null: false
    t.string "description_en", null: false
    t.string "description_de", null: false
    t.string "description_fr", null: false
    t.string "description_ja", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_de"], name: "index_rules_on_name_de", unique: true
    t.index ["name_en"], name: "index_rules_on_name_en", unique: true
    t.index ["name_fr"], name: "index_rules_on_name_fr", unique: true
    t.index ["name_ja"], name: "index_rules_on_name_ja", unique: true
  end

  create_table "source_types", charset: "utf8", force: :cascade do |t|
    t.string "name_en", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_de"
    t.string "name_fr"
    t.string "name_ja"
    t.index ["name_en"], name: "index_source_types_on_name_en", unique: true
  end

  create_table "sources", charset: "utf8", force: :cascade do |t|
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

  create_table "spell_aspects", charset: "utf8", force: :cascade do |t|
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

  create_table "spell_types", charset: "utf8", force: :cascade do |t|
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

  create_table "spells", charset: "utf8", force: :cascade do |t|
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

  create_table "survey_record_series", charset: "utf8", force: :cascade do |t|
    t.string "name_en"
    t.string "name_de"
    t.string "name_fr"
    t.string "name_ja"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "survey_records", charset: "utf8", force: :cascade do |t|
    t.string "name_en"
    t.string "name_de"
    t.string "name_fr"
    t.string "name_ja"
    t.text "description_en"
    t.text "description_de"
    t.text "description_fr"
    t.text "description_ja"
    t.string "solution", limit: 1000
    t.string "patch"
    t.integer "series_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order"
    t.index ["order"], name: "index_survey_records_on_order"
    t.index ["series_id"], name: "index_survey_records_on_series_id"
  end

  create_table "titles", charset: "utf8", force: :cascade do |t|
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

  create_table "tomestone_rewards", charset: "utf8", force: :cascade do |t|
    t.integer "cost"
    t.integer "collectable_id"
    t.string "collectable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tomestone"
    t.index ["collectable_id", "collectable_type"], name: "index_tomestone_rewards_on_collectable_id_and_collectable_type"
    t.index ["tomestone"], name: "index_tomestone_rewards_on_tomestone"
  end

  create_table "user_characters", charset: "utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_user_characters_on_character_id"
    t.index ["user_id", "character_id"], name: "index_user_characters_on_user_id_and_character_id", unique: true
    t.index ["user_id"], name: "index_user_characters_on_user_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
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
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "versions", charset: "utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "collectable_type", limit: 191
    t.bigint "collectable_id"
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.text "object_changes", size: :long
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "votes", charset: "utf8", force: :cascade do |t|
    t.integer "deck_id"
    t.integer "user_id"
    t.integer "score", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id", "user_id"], name: "index_votes_on_deck_id_and_user_id", unique: true
    t.index ["deck_id"], name: "index_votes_on_deck_id"
  end

end
