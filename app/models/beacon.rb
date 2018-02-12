class Beacon < ActiveRecord::Base
	belongs_to :user
	has_one :bleeapp, dependent: :nullify
	is_impressionable
	validates_format_of :uuid, :with => /\A\w{8}-{1}\w{4}-{1}\w{4}-{1}\w{4}-{1}\w{12}\z/i, :on => :create
	validates :uuid, uniqueness: { case_sensitive: false },presence: true
	validates :name, presence: true
end
