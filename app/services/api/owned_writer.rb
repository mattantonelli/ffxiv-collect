module Api
  class OwnedWriter
    WRITEABLE_COLLECTIONS = %w(emotes bardings hairstyles fashions facewear
                               orchestrions frames armoires outfits cards).freeze

    Result = Struct.new(:added, :already_owned, :invalid_ids, :total_owned, keyword_init: true)

    def self.writeable?(collection)
      WRITEABLE_COLLECTIONS.include?(collection.to_s)
    end

    def initialize(character, collection, ids)
      @character  = character
      @collection = collection.to_s
      @ids        = Array(ids).map { |id| Integer(id) rescue nil }.compact.uniq
    end

    def call
      singular   = @collection.singularize
      model      = @collection.classify.constantize
      join_model = "Character#{model.name}".constantize

      valid_ids = model.where(id: @ids).pluck(:id)
      invalid   = @ids - valid_ids
      owned_ids = @character.send("#{singular}_ids")
      new_ids   = valid_ids - owned_ids

      if new_ids.any?
        Character.bulk_insert(@character.id, join_model, singular.to_sym, new_ids)
      end

      Result.new(
        added:         new_ids.size,
        already_owned: (valid_ids - new_ids).size,
        invalid_ids:   invalid,
        total_owned:   owned_ids.size + new_ids.size
      )
    end
  end
end
