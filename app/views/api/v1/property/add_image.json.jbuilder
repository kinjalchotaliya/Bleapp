json.status          "Success"
json.message         "Images has been saved successfully"
json.property_id      @property.id
if @images.present?
json.data @images do |f|
    json.image      f.image
    json.image_id   f.id
    json.is_starred f.is_starred
end
end