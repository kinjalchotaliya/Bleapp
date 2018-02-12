class Property < ActiveRecord::Base
  # after_save :get_lat_long
  belongs_to :user
  validates :address, :address, :zip, :city, :state, presence: true

  has_many :bleeapps, dependent: :destroy
  has_many :favorite_properties, dependent: :destroy
  has_many :highlights, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_one :property_detail, dependent: :destroy
  has_one :property_schedule, dependent: :destroy
  validates :status, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  accepts_nested_attributes_for :property_detail
  accepts_nested_attributes_for :property_schedule
  accepts_nested_attributes_for :images
  is_impressionable
  geocoded_by :full_address,:latitude => :lat, :longitude => :lon
  validates_presence_of :lat,:lon,:validates_lat_long?,:message => "Please Add Proper Address"
  # before_validation :geocode,:if=> :address_changed? || :state_changed? || :zip_changed? || :city_changed? || :state_changed?,:message => "Please Add Proper Address"
  #,:if=> :address_changed? || :state_changed? || :zip_changed? || :city_changed? || :state_changed?,:message => "Please Add Proper Address"
  #, :if=> true #:if=> :address_changed? || :state_changed? || :zip_changed? || :city_changed? || :state_changed?
  # after_validation :lat_changed?
  # before_save :check_geo
  after_validation :geocode, if: ->(obj){  (obj.zip.present? && obj.zip_changed?) || (obj.state.present? && obj.state_changed?) }

  # after_validation :geocode,:if => lambda{ |obj| obj.address_changed? || obj.city_changed? || obj.zip_changed? ||obj.state_changed?  }
  # before_save :check_address_changed
  R = 3959

  def self.search(location)
    where("lower(address) LIKE ? OR lower(city) LIKE ?  OR lower(state) LIKE ? OR zip = ?", "#{location.downcase}%", "#{location.downcase}%", "#{location.downcase}%","#{location}")
  end

  def self.distance(lat1,lon1,distance)
    properties = Hash.new
    all.each do |p|
      lat2 = p.lat
      lon2 = p.lon
      dLat = (lat2-lat1) * Math::PI / 180
      dLon = (lon2-lon1) * Math::PI / 180
      a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(lat1 * Math::PI / 180 ) * Math.cos(lat2 * Math::PI / 180 ) *
        Math.sin(dLon/2) * Math.sin(dLon/2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      d = R * c
      properties[p] = d if d < distance
    end
    properties.sort_by{|k,v| v}.map { |a| a.delete_at(0)}
  end

  # def get_lat_long
  #   if (self.lat.nil? || self.lat == 0.0) || (self.lon.nil? || self.lon == 0.0)
  #     coordinates = Geocoder.coordinates("#{self.city},#{self.state},#{self.zip}")
  #     p coordinates.inspect
  #     self.update(lat: coordinates.first,lon: coordinates.last)
  #   end
  # end

  def self.get_state_list
    {
    "Alabama - AL"=>"AL", "Alaska - AK"=>"AK", "Arizona - AZ"=>"AZ", "Arkansas - AR"=>"AR", "California - CA"=>"CA", "Colorado - CO"=>"CO", "Connecticut - CT"=>"CT", "Delaware - DE"=>"DE", "Florida - FL"=>"FL", "Georgia - GA"=>"GA", "Hawaii - HI"=>"HI",
    "Idaho - ID"=>"ID", "Illinois - IL"=>"IL", "Indiana - IN"=>"IN", "Iowa - IA"=>"IA", "Kansas - KS"=>"KS", "Kentucky - KY"=>"KY", "Louisiana - LA"=>"LA", "Maine - ME"=>"ME", "Maryland - MD"=>"MD", "Massachusetts - MA"=>"MA", "Michigan - MI"=>"MI",
    "Minnesota - MN"=>"MN", "Mississippi - MS"=>"MS", "Missouri - MO"=>"MO", "Montana - MT"=>"MT", "Nebraska - NE"=>"NE", "Nevada - NV"=>"NV", "New Hampshire - NH"=>"NH", "New Jersey - NJ"=>"NJ", "New Mexico - NM"=>"NM", "New York - NY"=>"NY", "North Carolina - NC"=>"NC",
    "North Dakota - ND"=>"ND", "Ohio - OH"=>"OH", "Oklahoma - OK"=>"OK", "Oregon - OR"=>"OR", "Pennsylvania - PA"=>"PA", "Rhode Island - RI"=>"RI", "South Carolina - SC"=>"SC", "South Dakota - SD"=>"SD", "Tennessee - TN"=>"TN", "Texas - TX"=>"TX", "Utah - UT"=>"UT",
    "Vermont - VT"=>"VT", "Virginia - VA"=>"VA", "Washington - WA"=>"WA", "Washington DC - DC"=>"DC", "West Virginia - WV"=>"WV", "Wisconsin - WI"=>"WI", "Wyoming - WY"=>"WY"
    }
  end


  def is_favorite user
    FavoriteProperty.find_by(user_id: user.id, property_id:id).present?
      # user.favorite_properties.where(property_id:id).present?
  end

  def is_visited user
    # user.visited_bleapps..joins(:bleeapp).where("bleeapps.property_id=?",property.id).present?
    VisitedBleapp.where(user_id: user.id).joins(:bleeapp).where("bleeapps.property_id=?",id).present?
  end

  def validates_lat_long?
    lat != 0.0 && lon != 0.0
  end

  # def lat_changed?
  #   if full_address_changed? && !latitude_changed?
  #     self.errors.add(:address, "is not valid")
  #   end
  # end

  def full_address
    [state,zip].compact.join(',')
  end


  def check_address_changed
    if address_changed? || city_changed? || zip_changed? ||state_changed?
        lat = 0.0
        lon = 0.0
        # update_attributes(lat:0.0,lon:0.0)
        # p 11111111111111
    end
  end
end
