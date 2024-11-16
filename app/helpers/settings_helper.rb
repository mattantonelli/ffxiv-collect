module SettingsHelper
  def database_options(selected = nil)
    options_for_select([['Garland Tools', 'garland'], ['FFXIV Teamcraft', 'teamcraft']], selected)
  end

  def data_center_options(character)
    options_for_select(character.available_data_centers, character.pricing_data_center)
  end
end
