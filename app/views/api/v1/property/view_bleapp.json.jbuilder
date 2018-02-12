json.status          "Success"
json.message         "List of Bleapps"
json.data @bleapps do |bleapp|
  json.id                      bleapp.id
  json.title                   bleapp.title
  json.tags                    bleapp.tags
  json.description             bleapp.description
  json.uuid                    bleapp.beacon.present? ? bleapp.beacon.uuid : ""
  json.audio                   bleapp.audio.url if bleapp.audio.present?
  json.images                  bleapp.ble_images do |f|
    json.image      f.image
    json.image_id   f.id
  end
  json.isvisited							 VisitedBleapp.find_by(bleeapp_id: bleapp.id, user_id: @current_user.id).present?
end
