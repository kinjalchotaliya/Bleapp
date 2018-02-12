json.status          "Success"
json.message         "List of Bleapps"
json.data @bleapps do |bleapp|
  json.id                      bleapp.id
  json.title                   bleapp.title
  json.tags                    bleapp.tags
  json.description             bleapp.description
  json.uuid                    bleapp.beacon.uuid  if bleapp.beacon.present? 
  json.property_id             bleapp.property_id
  json.agent_id								 Property.find(bleapp.property_id).user_id
  json.images                  bleapp.ble_images do |f|
    json.image      f.image
    json.image_id   f.id
  end
end