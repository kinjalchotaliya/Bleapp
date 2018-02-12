json.status          "Success"
json.message         "List of Beacons"

json.data @beacons do |beacon|
  json.id                      beacon.id
  json.uuid                    beacon.uuid
  json.name                    beacon.name
  json.date										 beacon.date
  json.description						 beacon.description	
end