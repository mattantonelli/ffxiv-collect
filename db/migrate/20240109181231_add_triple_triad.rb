class AddTripleTriad < ActiveRecord::Migration[6.1]
  def change
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

    create_table "character_cards" do |t|
      t.integer "card_id"
      t.integer "character_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["card_id"], name: "index_character_cards_on_card_id"
      t.index ["character_id", "card_id"], name: "index_character_cards_on_character_id_and_card_id", unique: true
      t.index ["character_id"], name: "index_character_achievements_on_character_id"
    end

    create_table "character_npcs" do |t|
      t.integer "character_id"
      t.integer "npc_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["npc_id"], name: "index_character_npcs_on_npc_id"
      t.index ["character_id", "npc_id"], name: "index_character_npcs_on_character_id_and_npc_id", unique: true
      t.index ["character_id"], name: "index_character_achievements_on_character_id"
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
      t.index ["npc_id"], name: "index_decks_on_npc_id"
      t.index ["rule_id"], name: "index_decks_on_rule_id"
      t.index ["updated"], name: "index_decks_on_updated"
      t.index ["user_id"], name: "index_decks_on_user_id"
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
end
