class ApplicationRecord < ActiveRecord::Base
  before_save :nilify_blanks

  self.abstract_class = true

  def self.ransackable_attributes(auth_object = nil)
    %w(
      name_en name_de name_fr name_ja
      description_en description_de description_fr description_ja
      enhanced_description_en enhanced_description_de enhanced_description_fr enhanced_description_ja
      tooltip_en tooltip_de tooltip_fr tooltip_ja
      gender order order_group patch
      type_id item_id icon_id
    )
  end

  def self.ransackable_associations(auth_object = nil)
    %w(sources category type item)
  end

  private
  def nilify_blanks
    attributes.each do |attribute, value|
      if %w(gender patch pricing_data_center).include?(attribute)
        self[attribute] = nil unless value.present?
      end
    end
  end
end
