class FavoriteProperty < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
end
