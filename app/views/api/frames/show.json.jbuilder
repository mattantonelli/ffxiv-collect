json.cache! [@frame, I18n.locale] do
  json.partial! 'api/frames/frame', frame: @frame, owned: @owned
end
