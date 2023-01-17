json.query @query
json.count @frames.length
json.results do
  json.cache! [@frames, I18n.locale] do
    json.partial! 'api/frames/frame', collection: @frames, as: :frame
  end
end
