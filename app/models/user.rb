class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :authentication_tokens, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :favorite_properties, dependent: :destroy 
  has_many :highlights, dependent: :destroy
  has_many :visited_bleapps, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :beacons
  has_one :user_setting, dependent: :destroy
  has_one :agent_info, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable  
  validates :f_name, presence: true 
  validates :l_name, presence: true   
  validate :cellphone_format
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password, presence: {message: "Please enter password."}, length: { minimum: 8 }, on: :create
  accepts_nested_attributes_for :user_setting
  accepts_nested_attributes_for :agent_info
  validate :password_complexity

  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-zA-Z])(?=.*[0-9])/)
      errors.add :base, "Please use an alphanumeric password with at least 8 characters."
    end
  end

  def cellphone_format
    if cell_phone.present? and not cell_phone.match(/\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/)
      errors.add :base, "Please enter valid cell phone number."
    end
  end

  def self.get_agent(email)
    agent = find_by(email: email)
  end

  def full_name
    self.f_name +  ' ' + self.l_name
  end
end
