class ApplicationRecord < ActiveRecord::Base
  before_save :nilify_blanks

  self.abstract_class = true

  private
  def nilify_blanks
    attributes.each do |attribute, value|
      self[attribute] = nil unless value.present?
    end
  end
end
