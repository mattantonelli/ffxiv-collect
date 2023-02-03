module ManualCollection
  extend ActiveSupport::Concern
  include Collection

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
      collection.destroy(collectable)
      head :no_content
    else
      head :not_found
    end
  end

  private
  def verified?
    @character.verified_user?(current_user)
  end

  def verified_user?
    user_signed_in? && @character.present?
  end

  def display_verify_alert!
    return unless @character.present?

    if user_signed_in?
      unless verified?
        link = view_context.link_to(t('alerts.verify_ownership'), verify_character_path(@character))
        flash.now[:alert_fixed] = t('alerts.not_verified', link: link)
      end
    else
      flash.now[:alert_fixed] = t('alerts.not_signed_in_and_verified')
    end
  end
end
