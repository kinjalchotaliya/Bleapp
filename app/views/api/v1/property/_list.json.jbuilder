json.status         "Success"
json.message        message
json.data property do |record|
  json.id                      record.id
  json.status                  record.status
  json.address                 record.address
  json.city                    record.city
  json.state                   record.state
  json.zip                     record.zip
  json.lat                     record.lat
  json.lon                     record.lon
  if record.property_detail.present?
    json.type                    record.property_detail.property_type
    json.style                   record.property_detail.style
    json.price                   record.property_detail.price
    json.sqft                    record.property_detail.sqft
    json.lot_size                record.property_detail.lot_size
    json.yeat_built              record.property_detail.yeat_built
    json.beds                    record.property_detail.beds
    json.baths                   record.property_detail.baths
    json.mls                     record.property_detail.mls
    json.garage                  record.property_detail.garage
    json.heat                    record.property_detail.heat
    json.air                     record.property_detail.air
    json.water                   record.property_detail.water
    json.sewer                   record.property_detail.sewer
    json.description             record.property_detail.description
  end
  json.date                    record.property_schedule.date
  json.to_time                 record.property_schedule.to
  json.from_time               record.property_schedule.from
  json.images                  record.images.reorder('is_starred desc') do |f|
    json.image      f.image.url(:medium)
    json.image_id   f.id
    json.is_starred f.is_starred
  end
  json.favorite                record.is_favorite @current_user
  json.documents               record.documents do |f|
    json.file       f.file
    json.file_id    f.id
  end
  json.agent_id                record.user.id
  json.agent_f_name            record.user.f_name
  json.agent_l_name            record.user.l_name
  json.agent_cell_phone        record.user.cell_phone
  json.agent_email             record.user.email
  if record.user.agent_info.present?
    json.agent_office_phone    record.user.agent_info.office_phone
    json.agent_agency          record.user.agent_info.asso_agency
    json.agent_license_no      record.user.agent_info.license_no
    json.agent_avatar          record.user.agent_info.avatar
  end
  json.is_visited              record.is_visited @current_user
  json.has_audio               record.bleeapps.where('audio_file_name IS NOT NULL').exists?
end
