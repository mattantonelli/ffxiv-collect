$(document).on 'turbolinks:load', ->
  return unless $('#deck_search').length > 0

  $('#q_rule_id_eq').change ->
    $('#q_npc_id_eq').val('')
    $('#general').prop('checked', false)

  $('#q_npc_id_eq').change ->
    $('#q_rule_id_eq').val('')
    $('#general').prop('checked', false)

  $('#general').change ->
    $('#q_rule_id_eq').val('')
    $('#q_npc_id_eq').val('')
