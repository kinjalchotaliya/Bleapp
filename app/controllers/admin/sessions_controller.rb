class Admin::SessionsController < ApplicationController
  layout 'admin'
	def new
	end

	def create
  	user = User.find_by(:email =>"#{params[:admin][:email]}".downcase)
    if user.present?
      if user.role == "SUPER ADMIN" || user.role == "ADMIN"
        if user.valid_password?(params[:admin][:password])
          sign_in(User, user)
          gflash :success => "Logged in successfully."
          redirect_to admin_users_path
        else
          gflash :warning => "Enter Correct Password."
        	redirect_to admin_path
        end
      else
        gflash :warning => "You are not authorized to login."
      	redirect_to root_path
      end
    else
      gflash :warning => "Please enter correct credentials."
      redirect_to root_path
    end    	
  end

  def destroy
    reset_session
    sign_out(current_user)
    gflash :success => "Logged out successfully."
    redirect_to admin_path
  end
end
