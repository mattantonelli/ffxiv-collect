json.(frame, :id, :name, :item_name, :description, :patch, :item_id)

json.owned @owned.fetch(frame.id.to_s, '0%')
json.icon image_url('frame.png', skip_pipeline: true)
json.image image_url("frames/#{frame.id}.png", skip_pipeline: true)
json.image_flipped image_url("frames/#{frame.id}_2.png", skip_pipeline: true) unless @frame.portrait_only?
