json.status  "Success"
json.message "Agent details have been submitted successfully. Registration details will be sent via email."
json.user @agent, :id, :email, :f_name, :l_name, :cell_phone,:role
json.user @agent.agent_info, :office_phone, :asso_agency, :license_no,:avatar
json.user @token, :auth_token