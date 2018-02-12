class Api::V1::SessionController < Api::V1::BaseController
  before_action :define_current_user, except: [:create] 

  def create
  	user = User.find_by(:email =>"#{params[:user][:email]}".downcase)
    unless user.nil?
      if user.valid_password?(params[:user][:password])
        if user.role == "AGENT"
          unless user.agent_info.is_enable
            render_json({"status" => "Fail","is_enable" => user.agent_info.is_enable, "message" => "Real Estate Agents must be verified. A bleapp representative will be in touch shortly"}.to_json) 
            return
          else
          end            
        end  
          sign_in(User, user)
          @token = user.authentication_tokens.build
          @token.save 
          @current_user = current_user
        if current_user.role == "AGENT"
          render :file => 'api/v1/session/agent_signin'
        elsif current_user.role == "ADMIN"
          render_json({"status" => "Success", "message" => "Login successfully.","auth_token"=>current_user.authentication_tokens.first.auth_token,"user" => current_user}.to_json)
        else
          render :file => 'api/v1/session/user_signin'
        end
      else
        render_json({"status" => "Fail", "message" => "Please enter a valid password.","is_enable"=> ""}.to_json)
      end
    else
    	render_json({"status" => "Fail", "message" => "Please enter a valid email address.","is_enable"=> ""}.to_json)
    end  	
  end

  def destroy
    if @token.present?
      reset_session
      sign_out(@current_user)
      @token.destroy
      render_json({"status" => "Success", "message" => "Logout successfully."}.to_json)
    else
      render_json({"status" => "Fail", "message" => "Please login first."}.to_json)
    end
  end
end
