json.cache! @title do
  json.partial! 'api/titles/title', title: @title, owned: @owned
end
