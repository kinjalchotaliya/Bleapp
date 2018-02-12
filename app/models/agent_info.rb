class AgentInfo < ActiveRecord::Base
  belongs_to :user
  #validates :asso_agency, presence: true  
  validates :license_no, presence: true 
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/avatar_icon.png"
  #validates_attachment_presence :avatar
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  after_create :send_mail

  def avatar_url
  	self.avatar.url
  end

  def send_mail
    UserMailer.notifier_email(self.user).deliver_later
  end
end
