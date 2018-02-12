class PropertySchedule < ActiveRecord::Base
  belongs_to :property
  is_impressionable
end
