class ApiHelpController < ApplicationController
	http_basic_authenticate_with :name => "admin@bleapp.com", :password => "admin123"
  def index
  end
end
