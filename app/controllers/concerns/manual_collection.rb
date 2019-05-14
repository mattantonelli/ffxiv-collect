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
    @character.verified_user?(current_user)
  end

  def display_verify_alert!
    if user_signed_in? && @character.present? && !@character.verified?
      flash.now[:alert_fixed] = 'This character is unverified. If you wish to track manual collections for this ' \
        "character, please #{view_context.link_to 'verify your ownership', character_verify_path(@character)}."
    end
  end
end
