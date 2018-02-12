json.status          "Success"
json.message         "Documents has been saved successfully"
json.property_id    @property.id
json.data @property.documents.reverse do |f|
    json.file      f.file
    json.file_id   f.id
end