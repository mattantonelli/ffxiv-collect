json.(frame, :id, :name, :item_name, :description, :patch, :item_id)

json.owned @owned.fetch(frame.id.to_s, '0%')
json.icon image_url('frame.png', skip_pipeline: true)
