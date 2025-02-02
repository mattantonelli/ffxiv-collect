json.cache! [@character, @collectables] do
  json.partial! @partial, collection: @collectables, as: @collection.singularize
end
