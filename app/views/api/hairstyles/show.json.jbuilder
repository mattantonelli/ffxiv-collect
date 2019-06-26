json.cache! @hairstyle do
  json.partial! 'api/hairstyles/hairstyle', hairstyle: @hairstyle, owned: @owned
end
