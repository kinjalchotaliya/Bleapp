json.status  "Success"
json.message "Profile has been updated successfully."
json.user @user, :id,  :email, :f_name, :l_name, :cell_phone,:role
json.user @user.user_setting, :contact_by_email, :contact_by_sms, :work_with_agent
json.user @token, :auth_token

