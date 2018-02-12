class ApiIndexRenderer
  attr_reader :name, :link_ref, :method_type
  
  def initialize(name, link_ref, method_type)
    @name        = name
    @link_ref    = link_ref
    @method_type = method_type
  end
  
  class << self
    def passenger_api_index
      index_arr = []
      index_arr << ApiIndexRenderer.new("Sign In", "sign_in", "POST")
      index_arr << ApiIndexRenderer.new("User Registration","user_register", "POST")
      index_arr << ApiIndexRenderer.new("Edit User Account","edit_user_acc", "POST")
      index_arr << ApiIndexRenderer.new("Agent Registration","agent_register", "POST")
      index_arr << ApiIndexRenderer.new("Edit Agent Account","edit_agent_acc", "POST")
      index_arr << ApiIndexRenderer.new("Change Password","change_user_password", "POST")
      index_arr << ApiIndexRenderer.new("Forgot Password","forgot_user_password", "POST")
      index_arr << ApiIndexRenderer.new("Users Listing","list_user", "GET")
      index_arr << ApiIndexRenderer.new("Agents Listing","list_agent", "GET")
      index_arr << ApiIndexRenderer.new("Delete User","delete_user", "POST")
      index_arr << ApiIndexRenderer.new("Add Property","add_property", "POST")
      index_arr << ApiIndexRenderer.new("Edit Property","edit_property", "POST")
      index_arr << ApiIndexRenderer.new("Add bleapp","add_bleapp", "POST")
      index_arr << ApiIndexRenderer.new("Edit bleapp","edit_bleapp", "POST")
      index_arr << ApiIndexRenderer.new("Edit bleapp images","edit_bleapp_images", "POST")
      index_arr << ApiIndexRenderer.new("Favorite Property","favorite_property", "POST")
      index_arr << ApiIndexRenderer.new("Add Highlight","add_highlight", "POST")
      index_arr << ApiIndexRenderer.new("Edit Highlight","edit_highlight", "POST")
      index_arr << ApiIndexRenderer.new("Add Images","add_images", "POST")  
      index_arr << ApiIndexRenderer.new("Edit Image","edit_image", "POST")
      index_arr << ApiIndexRenderer.new("Add Documents","add_documents", "POST")
      index_arr << ApiIndexRenderer.new("Edit Document","edit_document", "POST")
      index_arr << ApiIndexRenderer.new("Take Tour","take_tour", "GET")
      index_arr << ApiIndexRenderer.new("View Listing","list_property", "GET")
      index_arr << ApiIndexRenderer.new("My Listing","my_list_property", "GET")
      index_arr << ApiIndexRenderer.new("View Favorite Property","get_favorite_property", "GET")
      index_arr << ApiIndexRenderer.new("View bleapp","get_bleapp", "GET")
      index_arr << ApiIndexRenderer.new("View Highlight","get_highlights", "GET")
      index_arr << ApiIndexRenderer.new("View Highlighted Properties","get_highlighted_properties", "GET")
      index_arr << ApiIndexRenderer.new("Delete Property","delete_property", "POST")
      index_arr << ApiIndexRenderer.new("Remove Favorite","remove_favorite", "POST")
      index_arr << ApiIndexRenderer.new("Remove Bleapp","remove_bleapp", "POST")
      index_arr << ApiIndexRenderer.new("Remove Highlight","remove_highlight", "POST")
      index_arr << ApiIndexRenderer.new("Filter Property","filter_property", "POST")
      index_arr << ApiIndexRenderer.new("Search Property","search_property", "POST")
      index_arr << ApiIndexRenderer.new("Feedback","feedback", "POST")
      index_arr << ApiIndexRenderer.new("View Feedback","view_feedback", "GET")
      index_arr << ApiIndexRenderer.new("List Feedback","get_feedback", "GET")
      index_arr << ApiIndexRenderer.new("Register Visit","register_visit", "POST")
      index_arr << ApiIndexRenderer.new("Get Beacon","get_beacon", "GET")
      index_arr << ApiIndexRenderer.new("Visit Beacon","visit_beacon", "POST")
      index_arr << ApiIndexRenderer.new("Get Property Attribute","get_attribute", "GET")
      index_arr << ApiIndexRenderer.new("Get bleapp Tags","get_tags", "GET")
      index_arr << ApiIndexRenderer.new("Get used Beacon","get_used_beacon", "GET")
      index_arr << ApiIndexRenderer.new("Get Property By Beacon","get_property_by_beacon", "GET")
      index_arr << ApiIndexRenderer.new("Get Agent Beacon","get_agent_beacon", "GET")
      index_arr << ApiIndexRenderer.new("Sign Out","sign_out", "POST")
      index_arr
    end    
  end
end