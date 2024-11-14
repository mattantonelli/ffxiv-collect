class ApplicationRecord < ActiveRecord::Base
  before_save :nilify_blanks

  self.abstract_class = true

  private
  def nilify_blanks
    attributes.each do |attribute, value|
      if %w(gender patch pricing_data_center).include?(attribute)
        self[attribute] = nil unless value.present?
      end
    end
  end
end
