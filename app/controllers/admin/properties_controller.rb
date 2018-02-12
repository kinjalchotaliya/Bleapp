class Admin::PropertiesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_property, only: [:show,:edit,:update,:destroy,:change_status]
	layout 'admin'
	def index
		@properties = Property.all#.paginate(:page => params[:page], :per_page => 15)
	end

	def new
		@property = Property.new
    # @state = Property.get_state_list
		@property.build_property_detail
		@property.build_property_schedule
		# @agents = User.select('id, email').where(role: 'AGENT')
	end

	def create
		@property = Property.create(properties_params)
		if @property.save
			@property.update_attributes(is_active: false) if @property.status != "For Sale"
			gflash :success => "Property has been created successfully..!"
	    redirect_to admin_properties_path
		else
      gflash :error => @property.errors.full_messages.first
      render :new
		end
	end

	def show
		@detail = @property.property_detail
		@schedule = @property.property_schedule
		@bleapps = @property.bleeapps
		@highlights = @property.highlights
	end

	# def show_images
	# 	@images = @property.images
	# end

	# def change_image
	# 	@image = Image.find(params[:id])
	# end

	def edit
    @state = Property.get_state_list
	end

	# def edit_bleapp
	# 	@bleapp = Bleeapp.find(params[:id])
	# end

	# def edit_highlight
	# 	@highlight = Highlight.find(params[:id])
	# end

	def update
    # render json:params
    # return
		if @property.update(properties_params)
			@property.update_attributes(is_active: false) if @property.status != "For Sale"
      # render :index
			gflash :success => "Property has been updated successfully..!"
      redirect_to admin_properties_path,  status: 301
		else

			gflash :error => @property.errors.full_messages.first
			render :edit
      # redirect_to admin_properties_path,  status: 301
		end
	end

	# def update_bleapp
	# 	@bleapp = Bleeapp.find(params[:id])
	# 	if @bleapp.update(bleapp_params)
	# 		gflash :success => "Bleapp has been updated successfully..!"
	# 		redirect_to admin_properties_path
	# 	else
	# 		gflash :error => @bleapp.errors.full_messages.first
	# 		redirect_to admin_properties_path
	# 	end
	# end

	# def update_highlight
	# 	@highlight = Highlight.find(params[:id])
	# 	if @highlight.update(highlight_params)
	# 		gflash :success => "Highlight has been updated successfully..!"
	# 		redirect_to admin_properties_path
	# 	else
	# 		gflash :error => @highlight.errors.full_messages.first
	# 		redirect_to admin_properties_path
	# 	end
	# end

	# def update_image
	# 	@image = Image.find(params[:id])
	# 	if @image.update_attributes(image: params[:image][:image])
	# 		gflash :success => "Image has been updated successfully..!"
	#     redirect_to admin_properties_path
	# 	else
	# 		gflash :error => @image.errors.full_messages.first
	# 		redirect_to admin_properties_path
	# 	end
	# end

	def destroy
		if @property.destroy
			gflash :success => "Property has been Deleted successfully..!"
	    redirect_to admin_properties_path
		else
			gflash :error => @property.errors.full_messages.first
			redirect_to admin_properties_path
		end
	end

	# def destroy_bleapp
	# 	@bleapp = Bleeapp.find(params[:id])
	# 	if @bleapp.destroy
	# 		gflash :success => "Bleapp has been Deleted successfully..!"
	#     redirect_to admin_properties_path
	# 	else
	# 		gflash :error => @bleapp.errors.full_messages.first
	# 		redirect_to admin_properties_path
	# 	end
	# end

	# def destroy_highlight
	# 	@highlight = Highlight.find(params[:id])
	# 	if @highlight.destroy
	# 		gflash :success => "Highlight has been Deleted successfully..!"
	#     redirect_to admin_properties_path
	# 	else
	# 		gflash :error => @highlight.errors.full_messages.first
	# 		redirect_to admin_properties_path
	# 	end
	# end

# For set property Active or Inactive
	def change_status
		if @property.is_active
			@property.update_attributes(is_active: false)
			redirect_to admin_properties_path
		else
			@property.update_attributes(is_active: true, status: "For Sale")
			redirect_to admin_properties_path
		end
	end

	private
	def set_property
		@property = Property.find(params[:id])
	end
	def properties_params
		params.require(:property).permit(:status,:address,:city,:state,:zip, :user_id, :property_detail_attributes =>[:id, :property_type, :style, :price, :sqft, :lot_size, :yeat_built, :beds, :baths, :mls, :garage, :heat, :air, :water, :sewer, :description],:property_schedule_attributes =>[:id, :date,:from,:to])
	end
	# def image_params
	# 	params.require(:image).permit(:image)
	# end
	# def bleapp_params
	# 	params.require(:bleeapp).permit(:title,:tags,:description)
	# end
	# def highlight_params
	# 	params.require(:highlight).permit(:title,:note,:image)
	# end
end
