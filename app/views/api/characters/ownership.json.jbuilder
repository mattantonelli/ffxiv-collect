json.cache! [@character, @collectables] do
  json.partial! "api/#{@collection}/#{@collection.singularize}", collection: @collectables, as: @collection.singularize
end
