module Collection
  extend ActiveSupport::Concern

  included do
    before_action :verify_privacy!, only: [:index, :type]
  end

  private
  def verify_privacy!
    if @character.present?
      if user_signed_in? && @character.private?(current_user)
        current_user.update(character_id: nil)
        flash[:error] = 'This character has been set to private and can no longer be tracked.'
        redirect_to root_path
      elsif !user_signed_in? && @character.private?
        cookies[:character] = nil
        flash[:error] = 'This character has been set to private and can no longer be tracked.'
        redirect_to root_path
      end
    end
  end
end
