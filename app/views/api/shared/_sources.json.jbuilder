json.sources do
  json.array! collectable.sources.each do |source|
    json.type source.type.name
    json.text source.related&.name || source.text
    json.(source, :related_type, :related_id)
  end
end
