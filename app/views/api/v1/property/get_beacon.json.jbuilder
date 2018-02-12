json.status          "Success"
json.message         "List of Beacons"
json.filter_beacon @filter_beacons do |bleapp|
  json.id                      bleapp.id
  json.uuid                   bleapp.uuid
  json.name                    bleapp.name
end
json.proxi_beacon @proxi_beacons do |bleapp|
  json.id                      bleapp.id
  json.uuid                   bleapp.uuid
  json.name                    bleapp.name
end