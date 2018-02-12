class Admin::FeedbacksController < ApplicationController
	before_action :authenticate_user!
	layout 'admin'
	def index
		users = User.where(role: "USER").pluck(:id)
		agents= User.where(role: "AGENT").pluck(:id)
		@feedbacks_user = Feedback.where(user_id: users)
		@feedbacks_agent = Feedback.where(user_id: agents)
	end

	def destroy
		@feedback = Feedback.find(params[:id])
		if @feedback.destroy
			gflash :success => "Feedback Deleted successfully..!"
			redirect_to admin_feedbacks_path
		else
			gflash :error => "Something went wrong..!"
			redirect_to admin_feedbacks_path
		end
	end
end
