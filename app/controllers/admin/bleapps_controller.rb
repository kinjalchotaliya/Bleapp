class Admin::BleappsController < ApplicationController
	before_action :authenticate_user!
	helper_method :resource
	layout 'admin'

	def index
		@bleapps = resource.bleeapps
	end

	def new
		@bleapp = resource.bleeapps.build
		@filter_beacons = Beacon.where(is_filter: 1)
		@proxi_beacons = Beacon.where(is_filter: 0)
	end

	def create
		old_bleapp = Bleeapp.where(beacon_id: params[:bleeapp][:beacon_id])
		# old_bleapp.update_all(beacon_id: nil) if old_bleapp.present?
		# raise old_bleapp.inspect
		old_bleapp.destroy_all if old_bleapp.present?
		@bleapp = resource.bleeapps.build(bleapp_params)
		if @bleapp.save
			if params[:file].present?
				params[:file].each do |file|
					@bleapp.ble_images.create(image: file)
				end
			end
			gflash :success => "Bleapp has been created successfully..!"
			redirect_to admin_bleapps_path(id: resource.id)
		else
			gflash :error => @bleapp.errors.full_messages.first
			redirect_to admin_properties_path
		end
	end

	def edit
		@bleapp = Bleeapp.find(params[:id])
	end

	def update
		@bleapp = Bleeapp.find(params[:id])
		if @bleapp.update(bleapp_params)
			gflash :success => "Bleapp has been updated successfully..!"
			redirect_to admin_properties_path
		else
			gflash :error => @bleapp.errors.full_messages.first
			redirect_to admin_properties_path
		end
	end

	def destroy
		# raise params[:property_id].inspect
		@bleapp = Bleeapp.find(params[:id])
		params[:property_id] = @bleapp.property_id
		# @bleapp.destroy

		# if @bleapp.destroyed?
		#   gflash :success => "Bleapp has been Deleted successfully..!"
    #   redirect_to admin_bleapps_path(id: resource.id)
		# else
		# 	gflash :error => @bleapp.errors.full_messages.first
		# 	redirect_to admin_bleapps_path(id: resource.id)
		# end

		if @bleapp.update_attributes(beacon_id: nil)
			gflash :success => "Bleapp has been Deleted successfully..!"
	     redirect_to admin_bleapps_path(id: resource.id)
		else
			gflash :error => @bleapp.errors.full_messages.first
			redirect_to admin_bleapps_path(id: resource.id)
		end
	end

	def add_more_image
		@bleapp = Bleeapp.find(params[:id])
		unless @bleapp.blank? && params[:file].nil?
			params[:file].each do |file|
					@bleapp.ble_images.create(image: file)
			end
		end
		gflash :success => "Image(s) upload successfully."
		redirect_to admin_ble_images_path(id: @bleapp.id)
	end

	def get_assign_beacon
		beacon = Beacon.find_by(:uuid => "#{params[:uuid]}")
		bleapp = beacon.bleeapp
		if bleapp.present?
      render :json => {:valid=> false,:property => bleapp.property_id}
    else
      render :json => {:valid=> true}
    end
	end

	def images
		@bleapp = Bleeapp.find(params[:id])
	end

	def delete_image
		@image = BleImage.find(params[:id])
		@bleapp = @image.bleeapp
		@image.destroy
		redirect_to admin_ble_images_path(id: @bleapp.id)
	end

	def ble_audio
		@bleapp = Bleeapp.find( params[ :id ] )
	end

	def add_audio
		@bleapp = Bleeapp.find( params[ :id ] )
		
		if params[ :audio ] and
		   @bleapp.update_attributes( audio: params[ :audio ] ) and 
		   @bleapp.audio.present?
			gflash :success => "Audio updated successfully."
		else
			gflash :error => "Audio cannot be updated. Try another file."
		end

		redirect_to admin_ble_audio_path( id: @bleapp.id )
	end

	def delete_audio
		@bleapp = Bleeapp.find( params[ :id ] )
		@bleapp.audio.clear
		@bleapp.save
		
		gflash :success => "Audio was successfully deleted."
		redirect_to admin_ble_audio_path( id: @bleapp.id )
	end

	private
	def bleapp_params
		params.require(:bleeapp).permit(:title,:tags,:description,:beacon_id, :audio)
	end

	def resource
		@resource ||= Property.find(params[:id]) rescue Property.find(params[:property_id])
	end
end
