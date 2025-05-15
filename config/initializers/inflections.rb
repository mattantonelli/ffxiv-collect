# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'NPC'
  inflect.acronym 'NPCs'
  inflect.acronym 'XIV'
  inflect.acronym 'XIVAPI'

  inflect.irregular 'Import', 'Import'

  inflect.plural 'Armoire', 'Armoire'
  inflect.plural 'Fashion', 'Fashion'
  inflect.plural 'Orchestrion', 'Orchestrion'

  inflect.plural 'leve', 'leves'
  inflect.singular 'leves', 'leve'
  inflect.irregular 'leve', 'leves'

  inflect.irregular 'facewear', 'facewear'

  # Moogle Treasure Trove
  inflect.acronym 'II'
  inflect.acronym 'III'
  inflect.acronym 'IV'
end
