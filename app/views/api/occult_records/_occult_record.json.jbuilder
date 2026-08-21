json.(occult_record, :id, :name, :description, :location, :patch)
json.owned @owned.fetch(occult_record.id.to_s, '0%')
json.image occult_record.image_url

json.partial! 'api/shared/sources', collectable: occult_record
