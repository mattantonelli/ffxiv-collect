module ManualCollection
  extend ActiveSupport::Concern

  included do
    before_action :display_verify_alert!, only: :index
  end

  def add_collectable(collection, collectable)
    if verified?
      collection << collectable
      head :no_content
    else
      head :not_found
    end
  end

  def remove_collectable(collection, collectable)
    if verified?
      collection.delete(collectable)
      head :no_content
    else
      head :not_found
    end
  end

  private
  def verified?
    current_user&.id == @character.verified_user_id
  end
end
