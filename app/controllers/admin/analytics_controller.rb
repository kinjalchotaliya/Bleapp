class Admin::AnalyticsController < ApplicationController
	before_action :authenticate_user!
	layout 'admin'
	def index
		# for most Accessed Beacons
		@tab = 'beacons'
		if !params['tab'].nil?
				@tab = params['tab']
		end		
		@data = Hash.new
		impression = Impression.where(action_name: 'visit_beacon').pluck(:impressionable_id)
		array = impression.group_by{|x| x}.values
		Beacon.all.each do |beacon|
			array.each do |a|
				if a.first == beacon.id
					@data[beacon.name] = a.count
				end
			end
		end

		# for most viewed properties
		@properties = Hash.new
		impression = Impression.where(action_name: 'show').pluck(:impressionable_id)
		array = impression.group_by{|x| x}.values
		Property.all.each do |property|
			array.each do |a|
				if a.first == property.id
					@properties["#{property.address},#{property.city},#{property.state},#{property.zip}"] = a.count
				end
			end
		end
		@properties = @properties.sort_by {|k,v| v}.reverse.first(5)
	end

# For edit Mile Setting
	def mile_setting
		@setting = Setting.first
	end

	def update_setting
		@setting = Setting.first
		if @setting.update(setting_params)
			gflash :success => "Setting has been saved successfully..!"
			render :mile_setting
		else
			gflash :warning => @setting.errors
			render :mile_setting
		end
	end

	private
		def setting_params
			params.require(:setting).permit(:mile_for_filter,:mile_for_list)
		end
end
