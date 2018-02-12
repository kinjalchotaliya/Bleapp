class Admin::UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user, only: [:edit,:update,:destroy,:show,:login_permission]
	layout 'admin'

	def index
	end

	def show
	end
# Display List for User and Agent
	def list
		if current_user.role == "ADMIN" || current_user.role == "SUPER ADMIN"
      restrict_usage! if current_user.role == "ADMIN" && params[:role] == "ADMIN"
      @users = User.where(role: params[:role])
      @users << User.find_by(role: "SUPER ADMIN") if params[:role] == "ADMIN"
      @role = params[:role]
    end
	end

	def new
		@user = User.new
		@user.build_user_setting
	end

	def create
		user = User.create(users_params)
		if user.save
      unless user.role == "ADMIN"
  			info = user.build_user_setting(create_users_params[:user_setting]) if params[:user][:role] == "USER"
  			info = user.build_agent_info(create_agent_params[:agent_info]) if params[:user][:role] == "AGENT"
        if info.save
  				gflash :success => "#{user.role} has been created successfully..!"
  		    redirect_to admin_list_path(role: "#{user.role}")
  			else
  				role = user.role
  				user.destroy
  				gflash :error => info.errors.full_messages.first
  				redirect_to new_admin_user_path(role: "#{role}")
  			end
      else
        redirect_to admin_list_path(role: "#{user.role}")
      end
		else
			gflash :error => user.errors.full_messages.first
	    redirect_to new_admin_user_path(role: "#{user.role}")
		end
	end

	def edit
	end

	def update
    if params[:user][:current_password].present?
      if @user.valid_password?(params[:user][:current_password])
        if @user.update(update_users_password)
          #sign_in(:user, @user, :bypass => true) if @user == current_user
        else
          update_error
          return
        end
      else
        gflash :error => "Please enter valid password"
        render :edit
        return
      end
    end
		if @user.update(update_users_params)
      gflash :success => "#{@user.role} has been updated successfully..!"
      redirect_to admin_list_path(role: "#{@user.role}")
    else
    	update_error
    end
	end

  def update_error
    gflash :error => @user.errors.full_messages.first
    render :edit
  end

	def destroy
		role = @user.role
		if @user.destroy
			gflash :success => "Deleted successfully..!"
			redirect_to admin_list_path(role: role)
		else
			gflash :error => "Something went wrong..!"
			redirect_to admin_list_path(role: role)
		end
	end

	def login_permission
		if @user.agent_info.is_enable
			@user.agent_info.update_attributes(is_enable: false)
			redirect_to admin_list_path(role: "AGENT")
		else
			@user.agent_info.update_attributes(is_enable: true)
			redirect_to admin_list_path(role: "AGENT")
		end
	end

	def check_email_validation
		unless User.find_by(:email => params[:user][:email]).present?
      render :json => {:valid=> true}
    else
      render :json => {:valid=> false}
    end
	end

	private
  def restrict_usage!
    gflash :error => "You can't see admin list."
    redirect_to admin_users_path
    return
  end

	def set_user
		@user = User.find(params[:id])
	end

  def user_set_params
    params.require(:user).permit()
  end

  def users_params
    params.require(:user).permit(:f_name,:l_name,:cell_phone,:email,:password,:role)
  end

  def create_users_params
    params.require(:user).permit(:f_name,:l_name,:cell_phone,:email,:password,:role,:user_setting => [:contact_by_email,:contact_by_sms,:work_with_agent])
  end

  def create_agent_params
    params.require(:user).permit(:f_name,:l_name,:cell_phone,:email,:password,:role,:agent_info => [:office_phone,:asso_agency,:license_no,:avatar])
  end

  def update_users_params
    params.require(:user).permit(:f_name,:l_name,:cell_phone,:user_setting_attributes => [:contact_by_email,:contact_by_sms,:work_with_agent],:agent_info_attributes => [:office_phone,:asso_agency,:license_no,:avatar,:id])
  end

  def update_users_password
    params.require(:user).permit(:password,:password_confirmation)
  end
end
