class ApplicationRecord < ActiveRecord::Base
  before_save :nilify_blanks

  self.abstract_class = true

  def self.ransackable_attributes(auth_object = nil)
    %w(
      name_en name_de name_fr name_ja
      description_en description_de description_fr description_ja
      tooltip_en tooltip_de tooltip_fr tooltip_ja
      type_id item_id order order_group patch
    )
  end

  def self.ransackable_associations(auth_object = nil)
    %w(sources category type item)
  end

  private
  def nilify_blanks
    attributes.each do |attribute, value|
      if %w(gender patch).include?(attribute)
        self[attribute] = nil unless value.present?
      end
    end
  end
end
