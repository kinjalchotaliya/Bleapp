json.status  "Success"
json.message "Login successfully."
json.user @current_user, :id, :email, :f_name, :l_name, :cell_phone,:role
json.user @current_user.user_setting, :contact_by_email, :contact_by_sms, :work_with_agent
json.user @token, :auth_token

