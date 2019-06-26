json.cache! @armoire do
  json.partial! 'api/armoires/armoire', armoire: @armoire, owned: @owned
end
