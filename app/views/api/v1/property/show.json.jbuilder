json.status          "Success"
json.message         "Property Detail"
json.data  do
  json.id                      @property.id
  json.status                  @property.status
  json.address                 @property.address
  json.city                    @property.city
  json.state                   @property.state
  json.zip                     @property.zip
  json.lat                     @property.lat
  json.lon                     @property.lon 
  json.type                    @property.property_detail.property_type
  json.style                   @property.property_detail.style
  json.price                   @property.property_detail.price
  json.sqft                    @property.property_detail.sqft
  json.lot_size                @property.property_detail.lot_size
  json.yeat_built              @property.property_detail.yeat_built
  json.beds                    @property.property_detail.beds
  json.baths                   @property.property_detail.baths
  json.mls                     @property.property_detail.mls
  json.garage                  @property.property_detail.garage
  json.heat                    @property.property_detail.heat
  json.air                     @property.property_detail.air
  json.water                   @property.property_detail.water
  json.sewer                   @property.property_detail.sewer
  json.description             @property.property_detail.description
  json.date                    @property.property_schedule.date
  json.to_time                 @property.property_schedule.to
  json.from_time               @property.property_schedule.from
  json.images                  @property.images.reorder('is_starred desc') do |f|
    json.image      f.image.url(:medium)
    json.image_id   f.id
    json.is_starred f.is_starred
  end
  json.favorite                FavoriteProperty.find_by(user_id: @current_user.id, property_id: @property.id).present?
  json.documents                @property.documents do |f|
    json.file       f.file
    json.file_id    f.id
  end 
  json.agent_id                @property.user.id
  json.agent_f_name            @property.user.f_name
  json.agent_l_name            @property.user.l_name
  json.agent_cell_phone        @property.user.cell_phone
  json.agent_email             @property.user.email 
  if @property.user.agent_info.present?
    json.agent_office_phone      @property.user.agent_info.office_phone
    json.agent_agency            @property.user.agent_info.asso_agency 
    json.agent_license_no        @property.user.agent_info.license_no 
    json.agent_avatar            @property.user.agent_info.avatar
  end  
  json.is_visited              Impression.find_by(impressionable_id: @property.id,user_id: @current_user.id, action_name: 'show').present?
end

json.bleapp_data @property.bleeapps do |bleapp|
  json.id                      bleapp.id
  json.title                   bleapp.title
  json.tags                    bleapp.tags
  json.description             bleapp.description
  json.uuid             			 bleapp.beacon.present? ? bleapp.beacon.uuid : ""
  json.images                  bleapp.ble_images do |f|
    json.image      f.image
    json.image_id   f.id
  end
  json.isvisited							 VisitedBleapp.find_by(bleeapp_id: bleapp.id, user_id: @current_user.id).present?	
end