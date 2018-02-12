class Api::V1::PropertyController < Api::V1::BaseController
  before_action :define_current_user, except: [:get_property_attribute, :get_bleapp_tags,:get_beacon]
  # impressionist actions: [:show]#,unique:[:session_hash]

# View Listing of property
  def index
  	if @current_user
  		setting_distance = Setting.first.mile_for_list
      # raise setting_distance.inspect
  		if params[:lat].present? && params[:lon].present?
        # @property = Property.where.not(is_active: false,status:'Sold').order("id DESC").includes(:property_detail).distance(params[:lat].to_f,params[:lon].to_f,distance)
        @property = Property.where.not(is_active: false,status:'Sold').includes(:property_detail).order("id DESC").near("#{params[:lat]},#{params[:lon]}",setting_distance)

        # @property = Property.where(is_active: true).distance(params[:lat].to_f,params[:lon].to_f,distance)
  			# @property.delete_if {|x| x.status == "Sold" ||  x.is_active == false }
  		else
  			@property = Property.where(status: "For Sale",is_active: true).order("id DESC").includes(:property_detail)
  		end
  		if @property.present?
  			render :file => 'api/v1/property/index'
  		else
  			render_json({"status" => "Fail", "message" => "No property found."}.to_json)
  		end
  	end
  end

# View My Listing of property
  def my_listing
  	if authorize_agent?
  		@property = @current_user.properties.where(is_active: true).includes(:property_detail).order("id DESC")#.where(status: "For Sale")
  		if @property.present?
  			render :file => 'api/v1/property/my_listing'
  		else
  			render_json({"status" => "Fail", "message" => "No property found."}.to_json)
  		end
  	else
  		render_json({"status" => "Fail", "message" => "Not authorize to view property(LogIn as Agent)."}.to_json)
  	end
  end


# View Favorite Listing of property
  def my_favorite
  	if @current_user
  		# fav = @current_user.favorite_properties.pluck(:property_id)
  		# @property = Property.where(id: fav, is_active: true)
      @property = Property.joins(:favorite_properties).where("properties.is_active=?",true).where("favorite_properties.user_id=?",@current_user.id).includes(:property_detail,:images).order("properties.id DESC")
      if @property.present?
  			render :file => 'api/v1/property/my_favorite'
  		else
  			render_json({"status" => "Fail", "message" => "No property found."}.to_json)
  		end
  	end
  end

# View Bleapps for property
  def view_bleapp
  	begin
  		property = Property.find(params[:property][:property_id])
			@bleapps = property.bleeapps
			if @bleapps.present?
				render :file => 'api/v1/property/view_bleapp'
			else
				render_json({"status" => "Fail", "message" => "No bleapp found"}.to_json)
			end
  	rescue
  	 	render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
  	end
  end

# View Highlights for property
	def view_highlight
		begin
			property = Property.find(params[:property][:property_id])
			@highlights = Highlight.where(user_id: @current_user.id, property_id: property.id)
			if @highlights.present?
				render :file => 'api/v1/property/view_highlight'
			else
				render_json({"status" => "Fail", "message" => "No highlights found"}.to_json)
			end
		rescue
			render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
		end
	end

# View Highlighted Property
	def highlighted_property
		if @current_user
			highlights = @current_user.highlights.pluck(:property_id)
  		if highlights.present?
  			@property = Property.where(id: highlights, is_active: true)
  			render :file => 'api/v1/property/index'
  		else
  			render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
  		end
  	end
	end
# Get property Attribute
	def get_property_attribute
		style = [{value: "1"},{value: "2"},{value: "3"},{value: "4"}]
		status = [{value: "For Sale"},{value: "Sold"}, {value: "Pending"}]
		type = [{value: "Home"},{value: "Townhome"},{value: "Condo"},{value: "Multi-Family"},{value: "Commercial"},{value: "Other"}] #,{value: "Land"},{value: "Multi-Family Home"}, {value: "Retail"},{value: "Single Family Home"},{value: "Patio Home"},{value: "Villa"},{value: "House"},{value: "Apartment"},{value: "Town House"},{value: "Manufactured"}
		beds = [{value: "0"},{value: "1"},{value: "2"},{value: "3"},{value: "4"},{value: "5+"}]
		baths = [{value: "0"},{value: "0.5"},{value: "1"},{value: "1.5"},{value: "2"},{value: "2.5"},{value: "3"},{value: "3.5"},{value: "4"},{value: "4.5"},{value: "5+"}]
		garage = [{value: "0"},{value: "1"},{value: "2"},{value: "3"},{value: "4"},{value: "5"},{value: "6"},{value: "7"},{value: "8"},{value: "9"},{value: "10+"}]
		heat = [{value: "Gas"},{value: "Oil"}, {value: "Solar"}, {value: "Geo-Thermal"},{value: "Electric"}]
		air = [{value: "None"}, {value: "Wall"}, {value: "Central"}]
		water = [{value: "City"}, {value: "Well"}]
		sewer = [{value: "City"}, {value: "Septic"}]
		sqrt = [{value:"250"},{value:"500"},{value:"750"},{value:"1000"},{value:"1250"},{value:"1500"},{value: "1750"},{value: "2000"},{value: "2250"},{value: "2500"},{value: "2750"},{value: "3000"},{value: "3250"},{value: "3500"},{value: "3750"},{value: "4000"}]
		render_json({"style" => style,"status" =>status,"type"=>type,"beds"=>beds,"baths"=>baths,"garage"=>garage,"heat"=>heat,"air"=>air,"water"=>water,"sewer"=>sewer,"sqrt"=>sqrt}.to_json)
	end

	def get_bleapp_tags
		#tags = [{value: "General"},{value: "Living Room"},{value: "Kitchen"},{value: "Bedroom"},{value: "Bathroom"},{value: "Garage"},{value: "Basement"},{value: "Outdoor"}, {value: "Space"},{value: "Mechanical"}]
		tags = Beacon.where("lower(name) != ?","wildcard").pluck(:name).uniq
		render_json({"tags" => tags}.to_json)
	end

# this API give property description for take a Tour functionality
	def show
		begin
  		@property = Property.find(params[:id])
      impressionist(@property)
			if @property.present?
				render_json({"status" => "Success", "message" => ""}.to_json)
			else
				render_json({"status" => "Fail", "message" => ""}.to_json)
			end
  	rescue => error
  		render_json({"status" => "Fail", "message" => error}.to_json)
  	end
	end

# Add New Property
	def create
		if authorize_agent?
			property = @current_user.properties.build(properties_params)
			if property.save
				property.update_attributes(lat: 0.0,lon: 0.0) if property.lat.nil? || property.lon.nil?
				property.update_attributes(is_active: false) if property.status == "Sold" || property.status == "Pending"
				property_detail = property.build_property_detail(property_details_params)
				if property_detail.save
					property_schedule = property.build_property_schedule(property_schedules_params)
					if property_schedule.save
						render_json({"status" => "Success", "message" => "Property has been saved successfully.","property_id" => property.id}.to_json)
					else
						property.destroy
						render_json({"status" => "Fail", "message" => property_schedule.errors.full_messages}.to_json)
					end
				else
					property.destroy
					render_json({"status" => "Fail", "message" => property_detail.errors.full_messages.first}.to_json)
				end
			else
				render_json({"status" => "Fail", "message" => property.errors.full_messages.first}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "Not authorize to add property(Login as agent)."}.to_json)
		end
	end

# Add new bleapp for property
	def add_bleapp
		if authorize_agent?
			begin
				property = Property.find(params[:bleapp][:property_id])
				beacon = Beacon.find_by(uuid: params[:uuid].downcase)
				bleapp = property.bleeapps.build(bleapp_params)
				bleapp.beacon_id = beacon.id
				if bleapp.save
					params[:images].each { |image|
	          i = bleapp.ble_images.create(image: image)
	          if i.save
	          else
	          	render_json({"status" => "Fail", "message" => i.errors.full_messages.first}.to_json)
	          	return
	          end
	        }
					render_json({"status" => "Success", "message" => "bleapp has been saved successfully.","bleapp_id" => bleapp.id}.to_json)
				else
					render_json({"status" => "Fail", "message" => bleapp.errors.full_messages.first}.to_json)
				end
			rescue => e
				p e.inspect
				render_json({"status" => "Fail", "message" => e}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "Not authorize to add bleapp(Login as agent)."}.to_json)
		end
	end

# Create Favorite
	def create_favorite
		if @current_user
			begin
				property = Property.find(params[:favorite][:property_id])
				if fav = @current_user.favorite_properties.build(property_id: property.id)
					if fav.save
						render_json({"status" => "Success", "message" => "Property added to favorite successfully."}.to_json)
					else
						render_json({"status" => "Fail", "message" => fav.errors.full_messages.first}.to_json)
					end
				else
					render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
				end
			rescue
				render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
			end
		end
	end

# Create Highlights
	def create_highlight
		if @current_user
			begin
				property = Property.find(params[:property][:property_id])
				if property.present?
					highlight = property.highlights.build(highlight_params)
					if highlight.save
						render_json({"status" => "Success", "message" => "Highlight has been saved successfully."}.to_json)
					else
						render_json({"status" => "Fail", "message" => highlight.errors.full_messages.first}.to_json)
					end
				else
					render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
				end
			rescue => e
				p e
				render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
			end
		end
	end

# Add Images for property
	def add_images
		if @current_user.present?
			@property = Property.find(params[:property_id])
			if @property.present?
				# if @property.images.present?
				# 	@property.images.destroy_all
				# end
				params[:images].each { |image|
	          i = @property.images.create(image: image)
	          if i.save
	          else
	          	render_json({"status" => "Fail", "message" => i.errors.full_messages.first}.to_json)
	          	return
	          end
	        }
	        @property.images.first.update_attributes(is_starred: true)
	        render :file => 'api/v1/property/add_image'
	    else
	    	render_json({"status" => "Fail", "message" => "No property found."}.to_json)
	    end
		end
	end

# Add Documents for Property
	def add_documents
		if @current_user.present?
			@property = Property.find(params[:property_id])
			if @property.present?
				if @property.documents.present?
					@property.documents.destroy_all
				end
				params[:files].each { |file|
	          i = @property.documents.create(file: file)
	          if i.save
	          else
	          	render_json({"status" => "Fail", "message" => i.errors.full_messages.first}.to_json)
	          	return
	          end
	        }
	        render :file => 'api/v1/property/add_document'
	      #render_json({"status" => "Success", "message" => "Documents has been saved successfully."}.to_json)
	    else
	    	render_json({"status" => "Fail", "message" => "No property found."}.to_json)
	    end
		end
	end

# Edit Property Document
	def edit_document
		if authorize_agent?
			begin
				@file = Document.find(params[:file_id])
				if @file.present?
					@file.update_attributes(file: params[:file])
					render_json({"status" => "Success", "message" => "Document has been updated successfully."}.to_json)
				else
					render_json({"status" => "Fail", "message" => "No Document found.."}.to_json)
				end
			rescue
				render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "Not authorize to update Document(Login as agent)."}.to_json)
		end
	end

# Edit Bleapp
	def edit_bleapp
		if authorize_agent?
			begin
				bleapp = Bleeapp.find(params[:bleapp][:id].to_i)
				if bleapp.update(bleapp_params)
					# if bleapp.ble_images.present?
					# 	bleapp.ble_images.destroy_all
					# end
					# params[:images].each { |image|
		   #        i = bleapp.ble_images.create(image: image)
		   #        if i.save
		   #        else
		   #        	render_json({"status" => "Fail", "message" => i.errors.full_messages.first}.to_json)
		   #        	return
		   #        end
		   #      }
					render_json({"status" => "Success", "message" => "bleapp has been updated successfully."}.to_json)
				else
					render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
				end
			rescue => e
				render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "Not authorize to update bleapp(Login as agent)."}.to_json)
		end
	end

	def edit_bleapp_images
		bleapp = Bleeapp.find(params[:bleapp_id].to_i)
		if bleapp.ble_images.present?
			bleapp.ble_images.destroy_all
		end
		if bleapp.present?
			params[:images].each { |image|
        i = bleapp.ble_images.create(image: image)
        if i.save
        else
        	render_json({"status" => "Fail", "message" => i.errors.full_messages.first}.to_json)
        	return
        end
      }
      render_json({"status" => "Success", "message" => "bleapp has been updated successfully."}.to_json)
		else
			render_json({"status" => "Success", "message" => "bleapp not found."}.to_json)
		end
	end
# Edit property detail
	def edit
		if authorize_agent?
			begin
				property = Property.find(params[:property][:property_id])
				if property
					property.update_attributes(properties_params)
					property.update_attributes(is_active: false) if property.status != "For Sale"
					property.update_attributes(lat: 0.0,lon:0.0) if property.lat.nil? || property.lon.nil?
					property_detail = property.property_detail.update(property_details_params)
					property_schedule = property.property_schedule.update(property_schedules_params)
					render_json({"status" => "Success", "message" => "Property has been updated successfully.","property_id" => property.id}.to_json)
				else
					render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
				end
			rescue
				render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "Not authorize to update property(Login as agent)."}.to_json)
		end
	end

# Edit property images
	def edit_image
		if authorize_agent?
			if params[:images].present?
				i = 0
				# For edit group of images
				params[:images].each do |image|
					@image = Image.find(params[:image_ids][i])
					i = i + 1
					if @image.present?
						@image.update_attributes(image: image)
					else
						render_json({"status" => "Fail", "message" => "No Image found.."}.to_json)
						return
					end
				end
				#render_json({"status" => "Success", "message" => "Images has been updated successfully."}.to_json)
			end
			# For add group of images
			@property = Property.find(params[:property_id])
			if params[:new_images].present?
				params[:new_images].each { |image|
          i = @property.images.create(image: image)
          if i.save
          else
          	render_json({"status" => "Fail", "message" => i.errors.full_messages.first}.to_json)
          	return
          end
        }
			end
			# for Delete group of images
			if params[:delete_images].present?
				images = Image.where(id: params[:delete_images])
				images.destroy_all
			end
			begin
				if params[:starred_id].present?
					@property.images.update_all(is_starred: false)
					image = Image.find(params[:starred_id]).update_attributes(is_starred: true)
				elsif params[:starred_image].present?
					@property.images.update_all(is_starred: false)
					@property.images.create(image: params[:starred_image], is_starred: true)
				end
				@images = @property.images.where(is_starred: false).order(:id)
				if @images.present?
					@images.unshift(@property.images.where(is_starred: true).first)
				else
					@images = @property.images
				end
				render :file => 'api/v1/property/add_image'
			rescue => e
				p e
				render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "Not authorize to update Image(Login as agent)."}.to_json)
		end
	end

# Edit Highlights
	def edit_highlight
		if @current_user
			begin
				highlight = Highlight.find(params[:highlight_id])
				if highlight.present?
					if highlight.update(highlight_params)
						if params[:property][:delete_image] == "true"
							highlight.image = nil
							highlight.save
						end
						render_json({"status" => "Success", "message" => "Highlight has been updated successfully.","data" => highlight}.to_json)
					else
						render_json({"status" => "Fail", "message" => highlight.errors.full_messages.first}.to_json)
					end
				else
					render_json({"status" => "Fail", "message" => "No highlight found."}.to_json)
				end
			 rescue => e
			 	p e
			 	render_json({"status" => "Fail", "message" => "No highlight found."}.to_json)
			 end
		end
	end
	def destroy
		unless authorize_user?
			begin
				property = Property.find(params[:property][:property_id])
				if property.destroy
					render_json({"status" => "Success", "message" => "Property has been deleted successfully."}.to_json)
				else
					render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
				end
			rescue
				render_json({"status" => "Fail", "message" => "No property found."}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "Not authorize to delete property."}.to_json)
		end
	end

	def destroy_image
		unless authorize_user?
			begin
				image = Image.find(params[:image][:image_id])
				if image.destroy
					render_json({"status" => "Success", "message" => "Image has been deleted successfully."}.to_json)
				else
					render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
				end
			rescue
				render_json({"status" => "Fail", "message" => "No image found."}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "Not authorize to delete image."}.to_json)
		end
	end

	def destroy_favorite
		begin
			property = Property.find(params[:property][:property_id].to_i)
			favorite = FavoriteProperty.find_by(property_id: property.id, user_id: @current_user.id)
			if favorite.destroy
				render_json({"status" => "Success", "message" => "Favorite property has been removed successfully."}.to_json)
			else
				render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
			end
		rescue => error
			render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
		end
	end

	def destroy_bleapp
		begin
			bleapp = Bleeapp.find(params[:bleapp_id].to_i)
			if bleapp.update_attributes(beacon_id: nil)
				render_json({"status" => "Success", "message" => "bleapp has been removed successfully."}.to_json)
			else
				render_json({"status" => "Fail", "message" => "Error"}.to_json)
			end
		rescue => error
			render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
		end
	end

	def destroy_highlight
		begin
			highlight = Highlight.find(params[:highlight_id].to_i)
			if highlight.destroy
				render_json({"status" => "Success", "message" => "Highlight has been removed successfully."}.to_json)
			else
				render_json({"status" => "Fail", "message" => "Error"}.to_json)
			end
		rescue => error
			render_json({"status" => "Fail", "message" => "Something went wrong."}.to_json)
		end
	end

	def filter_property
 		ids = Array.new

    params[:max_price] = 500000000000000000000000000000000000000 unless params[:max_price].present?
    params[:min_price] = 0 unless params[:min_price].present?


    if params[:min_price].present? || params[:max_price].present?
      property_ids = PropertyDetail.where("price between ? and ?",params[:min_price].to_i,params[:max_price].to_i).pluck(:property_id)
      ids << property_ids
      # p ids
    end
    if params[:types].present?
    	types = params[:types].split(',')
      property_ids = PropertyDetail.where("property_type IN (?)",types).pluck(:property_id)
      ids << property_ids
      # p ids
    end
    if params[:beds].present?
    	array = Array.new
    	case params[:beds]
			when "0+"
			  array = ['0+','1+','2+','3+','4+','5+']
			when "1+"
			  array = ['1+','2+','3+','4+','5+']
			when "2+"
			  array = ['2+','3+','4+','5+']
			when "3+"
			  array = ['3+','4+','5+']
			when "4+"
			  array = ['4+','5+']
			when "5+"
			  array = ['5+']
			end
      property_ids = PropertyDetail.where("beds IN (?)",array).pluck(:property_id)
      ids << property_ids
      # p ids
    end
    if params[:baths].present?
    	array = Array.new
    	case params[:baths]
			when "0+"
			  array = ['0+','0.5+','1+','1.5+','2+','2.5+','3+','3.5+','4+','4.5+','5+']
			when "1+"
			  array = ['1+','1.5+','2+','2.5+','3+','3.5+','4+','4.5+','5+']
			when "2+"
			  array = ['2+','2.5+','3+','3.5+','4+','4.5+','5+']
			when "3+"
			  array = ['3+','3.5+','4+','4.5+','5+']
			when "4+"
			  array = ['4+','4.5+','5+']
			when "5+"
			  array = ['5+']
			end
      property_ids = PropertyDetail.where("baths IN (?)",array).pluck(:property_id)
      ids << property_ids
      # p ids
    end
    if params[:min_sqrt].present?
      property_ids = PropertyDetail.where("sqft > ?",params[:min_sqrt].to_f).pluck(:property_id)
      ids << property_ids
      # p ids
    end

 		if params[:lat].present? && params[:lon].present?
 		  # distance = Setting.first.mile_for_filter
    	# @properties = Property.where(is_active: true).distance(params[:lat].to_f,params[:lon].to_f,distance)

      setting_distance = Setting.first.mile_for_filter
      @properties = Property.where(is_active: true).near("#{params[:lat]},#{params[:lon]}",setting_distance)
      #property_ids = Property.where("lower(address) LIKE ? OR lower(city) LIKE ?  OR lower(state) LIKE ? OR zip = ?", "#{location.downcase}%", "#{location.downcase}%", "#{location.downcase}%",location).pluck(:id)
    	ids << property_ids#.map(&:id)
    	p "property via location #{@properties.map(&:id)}".inspect if @properties.present?
    	unless @properties.present?
    		@properties = ["any"]
    	end
    end

    if params[:keyword].present?
    	keyword = params[:keyword]
    	property_details = PropertyDetail.where("lower(mls) = ? OR lower(garage) = ?  OR lower(heat) = ? OR lower(air) = ? OR lower(water) = ? OR lower(sewer) = ? OR lower(description) LIKE ?", "#{keyword.downcase}", "#{keyword.downcase}", "#{keyword.downcase}","#{keyword.downcase}","#{keyword.downcase}","#{keyword.downcase}","%#{keyword.downcase}%").pluck(:property_id)
    	bleapps = Bleeapp.where("lower(title) = ? OR lower(description) = ?"  ,"#{keyword.downcase}","#{keyword.downcase}").pluck(:property_id)
    	highlights = Highlight.where("lower(title) = ? OR lower(note) = ?"  ,"#{keyword.downcase}","#{keyword.downcase}").pluck(:property_id)
    	ids << property_details if property_details.present?
    	# p ids
    	ids << bleapps if bleapps.present?
    	# p ids
    	ids << highlights if highlights.present?
      # p ids
      unless property_details.present? || bleapps.present? || highlights.present?
	      render_json({"status" => "Fail", "message" => "No result found."}.to_json)
	      return
	    end
    end

    if ids.present?
    	ids = ids.inject(&:&)
    	ids = [nil] unless ids.present?
    end

    case params[:view].to_i
		when 1
		  highlights = @current_user.highlights.pluck(:property_id)
		  # p highlights
	    highlights = ids & highlights if ids.present?
	    @property = Property.where(id: highlights, is_active: true)
		when 2
			fav = @current_user.favorite_properties.pluck(:property_id)
			# p fav
    	fav = ids & fav if ids.present?
    	@property = Property.where(id: fav, is_active: true)
		when 3
		  list = @current_user.properties.pluck(:id)
    	list = ids & list if ids.present?
    	@property = Property.where(id: list, is_active: true)
		else
		  @property = Property.where(id: ids,status: "For Sale",is_active: true ) if ids.present?
		end

		# unless @property.present?
		# 	render_json({"status" => "Fail", "message" => "No result found."}.to_json)
		# 	return
		# end

		if @properties.present?
			# p @property.inspect
	  	if @property.present? || @property == []
	  		# p "In Property condition"
	  		if @properties[0] != "any"
          # @properties.delete_if{|p| p.status != "For Sale"} if params[:view] == "4"
          p 1111111111111111111111111111
		  		p @properties = @properties.where("status = ?","For Sale") if params[:view] == "4"
          p 1111111111111111111111111111

		  		@property = @property & @properties if @properties[0] != "any"
	  		else
	  			@property = nil
	  		end
	  	else
	  		# p "In Else condition"
	  		if @properties[0] != "any"
		  		# @properties.delete_if{|p| p.status != "For Sale"} if params[:view] == "4"
          @properties = @properties.where("status = ?","For Sale") if params[:view] == "4"
		  		@property = @properties
		  	else
		  		@property = nil
		  	end
	  	end
	  end
    # p @property.sort { |a,b| a.created_at <=> b.created_at }


    if @property.class == Array && @property.present?
        @property = @property.sort { |a,b| b.id <=> a.id }
    elsif @property.present?
        @property = @property.order("id DESC")
    end

    # p  @property
  	if @property.present?
      # @property = @property.order("id DESC")
			render :file => 'api/v1/property/index'
		else
			render_json({"status" => "Fail", "message" => "No result found."}.to_json)
		end
	end

	def search_property
		case params[:view].to_i
		when 1
		  highlights = @current_user.highlights.pluck(:property_id)
    	@property = Property.where(id: highlights, is_active: true).search(params[:location])
		when 2
			fav = @current_user.favorite_properties.pluck(:property_id)
    	@property = Property.where(id: fav, is_active: true).search(params[:location])
		when 3
		  list = @current_user.properties.pluck(:id)
    	@property = Property.where(id: list, is_active: true).search(params[:location])
		else
		  @property = Property.where(is_active: true).search(params[:location])
		end

		if @property.present?
			render :file => 'api/v1/property/index'
		else
			render_json({"status" => "Fail", "message" => "No result found."}.to_json)
		end
	end

	def get_beacon
    # ble[] = Bleeapp.new
    # bleeapps  = Property.near([params[:latitude],params[:longitude]]).includes(:bleeapps).map  {|b|  b.bleeapps}
    # beacons = bleeapps.map {|b| b.beacon}
    # p 111111111111111111111111111
    filter_radius = Setting.first.mile_for_filter
    # p 111111111111111111111111111

    near_property = Property.near([params[:latitude],params[:longitude]],filter_radius)
    property_bleeapps = Bleeapp.joins(:property).select("bleeapps.*").merge(near_property)
    beacons = Beacon.joins(:bleeapp).merge(property_bleeapps).select("beacons.*")
    # @filter_beacons = Beacon.where(is_filter: 1)
		# @proxi_beacons = Beacon.where(is_filter: 0)
    @filter_beacons = beacons.where(is_filter: 1)
		@proxi_beacons = beacons.where(is_filter: 0)
    # @filter_beacons = Bleeapp.joins(:beacons)
    if @filter_beacons.present? || @proxi_beacons.present?
			render :file => 'api/v1/property/get_beacon'
		else
			render_json({"status" => "Fail", "message" => "No beacon found."}.to_json)
		end
	end

	def visit_beacon
		@beacon = Beacon.find_or_create_by(uuid: params[:uuid],name: params[:name])
		i = Impression.where(action_name: 'visit_beacon').last
		i.impressionable_id = @beacon.id
		i.save
		if @beacon.save
			render_json({"status" => "Success", "message" => ""}.to_json)
		else
			render_json({"status" => "Fail", "message" => ""}.to_json)
		end
	end

	def register_visit
		@bleapp = Bleeapp.find(params[:bleapp_id])
		if @bleapp.present?
			visited = @bleapp.visited_bleapps.build(user_id: params[:user_id])
			if visited.save
				render_json({"status" => "Success", "message" => "Visit add successfully."}.to_json)
			else
				render_json({"status" => "Fail", "message" => visited.errors.full_messages.first}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "No bleapp found."}.to_json)
		end
	end

	def get_used_beacon

    #to run old and new api
      # p 11111111111111111111
      # p params.inspect
      # p 11111111111111111111
    if params[:user_id].present?
      @bleapps = Bleeapp.joins(:beacon).where("beacons.user_id=?",params[:user_id])
      # @bleapps = Bleeapp.joins(:beacon).where.not(beacon_id: nil).where("beacons.user_id=?",params[:user_id]).near([params[:latitude],params[:longitude]])
    else
		  @bleapps = Bleeapp.where.not(beacon_id: nil)
    end
		if @bleapps.present?
			render :file => 'api/v1/property/get_used_beacon'
		else
			render_json({"status" => "Fail", "message" => "No beacon found."}.to_json)
		end
	end

	def get_property_by_beacon
		beacon = Beacon.find_by(uuid: params[:uuid])
		if beacon.present?
			@bleapp = beacon.bleeapp
			if @bleapp.present?
				@property = @bleapp.property
				render :file => 'api/v1/property/show'
			else
				render_json({"status" => "Fail", "message" => "No beacon found."}.to_json)
			end
		else
			render_json({"status" => "Fail", "message" => "No beacon found."}.to_json)
		end
	end

	def get_agent_beacon
		@beacons = Beacon.where(user_id: params[:user_id])
		if @beacons.present?
			render :file => 'api/v1/property/agent_beacon'
		else
			render_json({"status" => "Fail", "message" => "No beacon found."}.to_json)
		end
	end


	private
		# def properties_params
		# 		params.require(:property).permit(:status,:address,:city,:state,:zip,:property_detail_attributes =>[:property_type,:style,:price,:sqft,:lot_size,:yeat_built,:beds,:baths,:mls,:garage,:heat,:air,:water,:sewer,:description],:property_schedule_attributes =>[:date,:from,:to])
		# end
		def properties_params
			params.require(:property).permit(:status,:address,:city,:state,:zip,:lat,:lon)
		end
		def property_details_params
			params.require(:property).permit(:property_type,:style,:price,:sqft,:lot_size,:yeat_built,:beds,:baths,:mls,:garage,:heat,:air,:water,:sewer,:description)
		end
		def property_schedules_params
			params.require(:property).permit(:date,:from,:to)
		end
		def property_images_params
			params.require(:property).permit(:image)
		end
		def bleapp_params
			params.require(:bleapp).permit(:title,:tags,:description)
		end
		def highlight_params
			params.require(:property).permit(:image,:title,:note,:user_id)
		end
end
