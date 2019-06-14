json.sources do
  json.array! collectable.sources.each do |source|
    json.type source.type.name
    json.(source, :text, :related_type, :related_id)
  end
end
