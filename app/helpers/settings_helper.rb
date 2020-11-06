module SettingsHelper
  def database_options(selected = nil)
    options_for_select([['Garland Tools', 'garland'], ['FFXIV Teamcraft', 'teamcraft']], selected)
  end
end
