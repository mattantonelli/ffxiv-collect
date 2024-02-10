json.(leve, :id, :name, :craft, :category, :level, :patch)

json.issuer leve.issuer_name

json.location do
  json.name leve.location.name
  json.region leve.location.region
  json.x leve.issuer_x
  json.y leve.issuer_y
end

json.item do
  json.id leve.item_id
  json.name leve.item&.name
  json.quantity leve.item_quantity
end
