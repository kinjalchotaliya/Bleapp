class Api::V1::BaseController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :bad_record
  #protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  protected
  def render_json(json)
    callback = params[:callback]
    response = begin
      if callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({:content_type => 'application/json', :text => response})
  end

  def define_current_user
    @token = AuthenticationToken.find_by(auth_token: params[:auth_token])
    if @token.present?
      @current_user = User.find(@token.user_id)
      unless @current_user.present? 
        render_json(:status =>"Fail",:message => "No user found with this #{params[:auth_token]} auth token")
      end
    else
      render_json(:status => "Fail",:message => "Invalid authtoken.")
    end
  end  

  def authorize_user?
    if @current_user.role == "USER"
      return true
    end
    return false   
  end
  def authorize_agent? 
    if @current_user.role == "AGENT"
      return true
    end
    return false  
  end
  def authorize_admin?
    if @current_user.role == "ADMIN"
      return true
    end
    return false  
  end
end
