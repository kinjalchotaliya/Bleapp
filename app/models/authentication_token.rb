class AuthenticationToken < ActiveRecord::Base
  belongs_to :user
  before_create :generate_token
  
  private
  def generate_token  
    token   = SecureRandom.hex
       while AuthenticationToken.find_by(auth_token: token )
         token = SecureRandom.hex
       end
    self.auth_token = token
  end 
end
