class UserSetting < ActiveRecord::Base
  belongs_to :user
  validates_inclusion_of :contact_by_email, :in => [true, false] 
  validates_inclusion_of :contact_by_sms, :in => [true, false] 
  validates_inclusion_of :work_with_agent, :in => [true, false] 
end
