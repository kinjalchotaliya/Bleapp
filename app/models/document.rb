class Document < ActiveRecord::Base
  belongs_to :property
  has_attached_file :file
	validates_attachment :file, :content_type => { :content_type => [/\Aapplication\/.*\Z/, /\Aimage\/.*\Z/] }
end
