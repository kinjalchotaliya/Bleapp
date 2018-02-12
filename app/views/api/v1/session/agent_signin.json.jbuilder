json.status  "Success"
json.message "Login successfully."
json.user @current_user, :id, :email, :f_name, :l_name, :cell_phone,:role
json.user @current_user.agent_info, :office_phone, :asso_agency, :license_no,:avatar
json.user @token, :auth_token 

