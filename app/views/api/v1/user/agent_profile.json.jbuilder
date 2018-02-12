json.status  "Success"
json.message "Profile has been updated successfully."
json.user @agent, :id, :email, :f_name, :l_name, :cell_phone,:role
json.user @agent.agent_info, :office_phone, :asso_agency, :license_no,:avatar
json.user @token, :auth_token 

