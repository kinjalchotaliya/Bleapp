class Admin::HighlightsController < ApplicationController
	before_action :authenticate_user!
	layout 'admin'
	def edit
		@highlight = Highlight.find(params[:id])
	end

	def update
		@highlight = Highlight.find(params[:id])
		if @highlight.update(highlight_params)
			gflash :success => "Highlight has been updated successfully..!"
			redirect_to admin_properties_path
		else
			gflash :error => @highlight.errors.full_messages.first
			redirect_to admin_properties_path
		end
	end

	def destroy
		@highlight = Highlight.find(params[:id])
		if @highlight.destroy
			gflash :success => "Highlight has been Deleted successfully..!"
	    redirect_to admin_properties_path
		else
			gflash :error => @highlight.errors.full_messages.first
			redirect_to admin_properties_path
		end
	end

	private
	def highlight_params
		params.require(:highlight).permit(:title,:note,:image)
	end
end
