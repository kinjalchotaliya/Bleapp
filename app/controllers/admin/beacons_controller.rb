class Admin::BeaconsController < ApplicationController
	before_action :authenticate_user!
	layout 'admin'
	def index
		@filter_beacons = Beacon.where(is_filter: 1)#.paginate(:page => params[:page], :per_page => 15)
		@proxi_beacons = Beacon.where(is_filter: 0)#.paginate(:page => params[:page], :per_page => 15)
		if params[:search].present? 
			if params[:is_filter] == "true"
				@filter_beacons = Beacon.where("(lower(uuid) like ? or lower(name) = ?) and is_filter = ?","%#{params[:search].downcase}","#{params[:search].downcase}",params[:is_filter]).paginate(:page => params[:page], :per_page => 10)
			else
				@proxi_beacons	= Beacon.where("(lower(uuid) like ? or lower(name) = ?) and is_filter = ?","%#{params[:search].downcase}","#{params[:search].downcase}",params[:is_filter]).paginate(:page => params[:page], :per_page => 10)
			end
		end
	end

	def new
		@beacon = Beacon.new
		@agents = User.where(role: 'AGENT')
	end

	def create
		beacon = Beacon.create(beacon_params)
		beacon.uuid.strip!
		beacon.uuid.downcase!
		if beacon.save
			gflash :success => "Beacon has been created successfully..!"
	    redirect_to admin_beacons_path
		else
			gflash :error => beacon.errors.full_messages.first
			redirect_to new_admin_beacon_path
		end
	end
	
	def edit
		@beacon = Beacon.find(params[:id])
		@agents = User.where(role: 'AGENT')
	end

	def update
		@beacon = Beacon.find(params[:id])
		if @beacon.update(beacon_params)
			@beacon.uuid.strip!
			@beacon.save
			if params[:deattach] == "true"
				@beacon.bleeapp.update_attributes(beacon_id: nil) if @beacon.bleeapp.present? 
			end	
			gflash :success => "Beacon has been updated successfully..!"
	    redirect_to admin_beacons_path
		else
			gflash :error => @beacon.errors.full_messages.first
			render :edit
		end
	end

	def destroy
		@beacon = Beacon.find(params[:id])
		@beacon.destroy
		gflash :success => "Beacon has been deleted successfully..!"
		redirect_to admin_beacons_path
	end

	def upload_csv
	end

	def import_csv
		file = params[:csv][:file].tempfile.path
		extension = params[:csv][:file].original_filename.split(".").last
		if extension.eql?("csv")
			beacons = SmarterCSV.process(file)
			error = []
			if beacons.present?
				beacons.each do |beacon|
					beacon[:uuid].remove!('+AC0')	if beacon[:uuid].present?
					beacon[:uuid].downcase! if beacon[:uuid].present?
					beacon[:date].remove!('+AC0') if beacon[:date].present?
					beacon[:agent_email].sub! '+AEA-', '@' if beacon[:agent_email].present?
					@user = User.find_by(email: beacon[:agent_email])
					if @user.present?
						b = @user.beacons.create(uuid: beacon[:uuid], name: beacon[:name], date: beacon[:date], description: beacon[:description])
						b.is_filter = false
						if b.save
						else
							error << beacon
						end
					else
						error << beacon	
					end	
				end
				if error.present?
					gflash :warning => "CSV contain some duplicate or invalid data"
					redirect_to admin_error_data_path(data: error)
				else
					gflash :success => "CSV has been Stored successfully..!"
	    		redirect_to admin_beacons_path
				end 
			end
		else
			gflash :error => "Only CSV file allow..!"
	    redirect_to admin_upload_csv_path
		end	
	end

	def error_data
		@data = params[:data]
	end

	def get_beacon
		@beacon = Beacon.find(params[:id])
		if @beacon.present?
      render :json => {:valid=> true,:name => @beacon.name}
    else
      render :json => {:valid=> false}
    end
	end

	private
		def beacon_params
			params.require(:beacon).permit(:uuid,:name,:is_filter,:user_id,:date,:description)
		end
end
