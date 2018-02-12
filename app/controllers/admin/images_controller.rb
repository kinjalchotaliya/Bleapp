class Admin::ImagesController < ApplicationController
	before_action :authenticate_user!
	layout 'admin'
	def index
		@property = Property.find(params[:id])
		@images = @property.images
	end

	def new
		@image = Image.new
		@property = Property.find(params[:id])
	end

	def create
		@property = Property.find(params[:image][:property_id])
		if params[:file].present?
			params[:file].each do |image|
				@image = @property.images.build(image: image)
				if @image.save
				else
					gflash :error => @image.errors.full_messages.first
					render :new,:id=>@property.id
				end
			end	
			redirect_to admin_images_path(id: @property.id)
		end
	end

	def edit
		@image = Image.find(params[:id])
	end

	def update
		@image = Image.find(params[:id])
		if @image.update_attributes(image: params[:image][:image])
			gflash :success => "Image has been updated successfully..!"
	    redirect_to admin_properties_path
		else
			gflash :error => @image.errors.full_messages.first
			redirect_to admin_properties_path
		end
	end

	def destroy
		@image = Image.find(params[:id])
		@property = @image.property
		if @image.destroy
			gflash :success => "Image has been Deleted successfully..!"
	    redirect_to admin_images_path(id: @property.id)
		else
			gflash :error => @property.errors.full_messages.first
			redirect_to admin_images_path(id: @property.id)
		end
	end

	private
	def image_params
		params.require(:image).permit(:image)
	end
end
