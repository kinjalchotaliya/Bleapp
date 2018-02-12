class Api::V1::UserController < Api::V1::BaseController
  before_action :define_current_user, except: [:register_user, :register_agent,:forgot_password,:reset_password] 

  def user_list
    if authorize_admin?
      @user = User.where(role: "USER")
      unless @user.blank?
        attribute=[]
        @user.each do |user|
          attribute << [user]
        end
        render_json({"status" => "Success", "attribute" => attribute}.to_json)  
      else
        render_json({"status" => "Success", "message" => "No user found."}.to_json)
      end
    else
      render_json({"status" => "Fail", "message" => "Not authorize to view users list(Login as admin)."}.to_json)
    end
  end

  def agent_list
    if authorize_admin?
      @user = User.where(role: "AGENT")
      unless @user.blank?
        attribute=[]
        @user.each do |user|
          attribute << [user]
        end
        render_json({"status" => "Success", "attribute" => attribute}.to_json)  
      else
        render_json({"status" => "Success", "message" => "No user found."}.to_json)
      end
    else
      render_json({"status" => "Fail", "message" => "Not authorize to view agents list(Login as admin)"}.to_json)
    end
  end

  def register_user
    @user = User.new(users_params)
    if @user.save
      @user.update_attributes(role: "USER")
      setting = @user.build_user_setting(user_set_params)
      if setting.save  
        sign_in(User, @user)
        @token = @user.authentication_tokens.build
        @token.save
        render :file => 'api/v1/user/user_register'
      else
        @user.destroy
        render_json({"status" => "Fail", "message" => setting.errors.full_messages.first}.to_json)  
      end
    else
      render_json({"status" => "Fail", "message" => @user.errors.full_messages.first}.to_json)
    end
  end

  def edit_user_account
   @user = User.find(params[:user][:id])
    if @user
      if @user == @current_user || authorize_admin? 
        if @user.update_attributes(update_users_params)
          if @user.user_setting.update(user_set_params)
            #render_json({"status" => "Success", "message" => "Profile updated Successfully"}.to_json)
            render :file => 'api/v1/user/user_profile'
          else
            render_json({"status" => "Fail", "message" => @user.user_setting.errors.full_messages.first}.to_json)
          end
        else 
          render_json({"status" => "Fail", "message" => @user.errors.full_messages.first}.to_json)
        end
      else  
        render_json({"status" => "Fail", "message" => "Not authorize to update user detail."}.to_json)
      end
    else
      render_json({"status" => "Fail", "message" => "No user found."}.to_json)
    end   
  end

  def register_agent
    @agent = User.new(users_params)
    if @agent.save
      @agent.update_attributes(role: "AGENT")
      info = @agent.build_agent_info(agent_info_params)
      if info.save
        sign_in(User, @agent)
        @token = @agent.authentication_tokens.build
        @token.save
        render :file => 'api/v1/user/agent_register'
      else
        @agent.destroy
        render_json({"status" => "Fail", "message" => info.errors.full_messages.first}.to_json)
      end
    else
      render_json({"status" => "Fail", "message" => @agent.errors.full_messages.first}.to_json)
    end
  end

  def edit_agent_account
    @agent = User.find(params[:user][:id].to_i)
    if @agent
      if @agent == @current_user || authorize_admin? 
        if @agent.update_attributes(update_users_params)
          if @agent.agent_info.update(agent_info_params)
            #render_json({"status" => "Success", "message" => "Profile updated Successfully"}.to_json)
            render :file => 'api/v1/user/agent_profile'
          else
            render_json({"status" => "Fail", "message" => @agent.agent_info.errors.full_messages.first}.to_json)
          end
        else 
          render_json({"status" => "Fail", "message" => @agent.errors.full_messages.first}.to_json)
        end
      else  
        render_json({"status" => "Fail", "message" => "Not authorize to update agent detail."}.to_json)
      end
    else
      render_json({"status" => "Fail", "message" => "No agent found."}.to_json)
    end   
  end

  def change_password
    if @current_user.valid_password?(params[:user][:current_password]) 
      if @current_user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        render_json({"status" => "Success", "message" => "Password has been updated successfully."}.to_json)
      else
        render_json({"status" => "Fail", "message" => @current_user.errors.full_messages.first}.to_json)
      end
    else
      render_json({"status" => "Fail", "message" => "Please reenter current password.."}.to_json)
    end         
  end

  def forgot_password
    resource = User.find_by_email("#{params[:user][:email]}".downcase)
    unless resource.nil?
      if user = User.send_reset_password_instructions(params[:user])
        render_json({:status => "Success", :message => "Please check your email."}.to_json)
      else
        render_json({:status => "Fail", :message => user.errors.full_messages.first}.to_json)
      end
    else
      render_json({:status => "Fail", :message => "This username could not be found."}.to_json)
    end
  end

  def destroy
    if authorize_admin?
      user = User.find(params[:user][:id])
      if user
        user.destroy
        render_json({"status" => "Success", "message" => "User has been deleted successfully."}.to_json)
      else
        render_json({"status" => "Fail", "message" => "No user found."}.to_json)
      end
    else
      render_json({"status" => "Fail", "message" => "Not authorize to delete user(Login as admin)."}.to_json)
    end
  end

  def create_feedback
    if @current_user
      feedback = @current_user.feedbacks.create(feedback_params)
      if feedback.save
        render_json({"status" => "Success", "message" => "Feedback submitted successfully."}.to_json)
      else
        render_json({:status => "Fail", :message => feedback.errors.full_messages.first}.to_json)
      end
    end
  end

  def view_feedback
    if params[:property_id].present?
      @feedback = Feedback.find_by(user_id: @current_user.id, property_id: params[:property_id])
      if @feedback.present?
        render :file => 'api/v1/user/feedback'
      else
        render_json({:status => "Fail", :message => "No feedback found."}.to_json)
      end
    else
      render_json({:status => "Fail", :message => "No property found."}.to_json)
    end
  end

  def get_feedback
    if authorize_admin?
      if params[:role].eql?("1")
        user_ids = User.where(role: "USER").pluck(:id)
      else
        user_ids = User.where(role: "AGENT").pluck(:id)
      end
      if feedback = Feedback.where(user_id: user_ids)
        render_json({"status" => "Success", "attribute" => feedback}.to_json)    
      else
        render_json({"status" => "Fail", "message" => "No feedback found."}.to_json)
      end
    else
      render_json({"status" => "Fail", "message" => "Not authorize to view feedback."}.to_json)
    end
  end

  private
  def users_params
    params.require(:user).permit(:f_name,:l_name,:cell_phone,:email,:password,:device_type,:device_token)
  end

  def user_set_params
    params.require(:user).permit(:contact_by_email,:contact_by_sms,:work_with_agent)
  end

  def update_users_params
    params.require(:user).permit(:f_name,:l_name,:cell_phone,:email)
  end

  def agent_info_params
    params.require(:user).permit(:office_phone,:asso_agency,:license_no,:avatar)
  end

  def feedback_params
    params.require(:feedback).permit(:rate,:intrested,:contactable,:comments,:property_id)
  end
end
