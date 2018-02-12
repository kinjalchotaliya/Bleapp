module Admin::PropertiesHelper
  def get_state_list
    {
    "Alabama - AL"=>"AL", "Alaska - AK"=>"AK", "Arizona - AZ"=>"AZ", "Arkansas - AR"=>"AR", "California - CA"=>"CA", "Colorado - CO"=>"CO", "Connecticut - CT"=>"CT", "Delaware - DE"=>"DE", "Florida - FL"=>"FL", "Georgia - GA"=>"GA", "Hawaii - HI"=>"HI",
    "Idaho - ID"=>"ID", "Illinois - IL"=>"IL", "Indiana - IN"=>"IN", "Iowa - IA"=>"IA", "Kansas - KS"=>"KS", "Kentucky - KY"=>"KY", "Louisiana - LA"=>"LA", "Maine - ME"=>"ME", "Maryland - MD"=>"MD", "Massachusetts - MA"=>"MA", "Michigan - MI"=>"MI",
    "Minnesota - MN"=>"MN", "Mississippi - MS"=>"MS", "Missouri - MO"=>"MO", "Montana - MT"=>"MT", "Nebraska - NE"=>"NE", "Nevada - NV"=>"NV", "New Hampshire - NH"=>"NH", "New Jersey - NJ"=>"NJ", "New Mexico - NM"=>"NM", "New York - NY"=>"NY", "North Carolina - NC"=>"NC",
    "North Dakota - ND"=>"ND", "Ohio - OH"=>"OH", "Oklahoma - OK"=>"OK", "Oregon - OR"=>"OR", "Pennsylvania - PA"=>"PA", "Rhode Island - RI"=>"RI", "South Carolina - SC"=>"SC", "South Dakota - SD"=>"SD", "Tennessee - TN"=>"TN", "Texas - TX"=>"TX", "Utah - UT"=>"UT",
    "Vermont - VT"=>"VT", "Virginia - VA"=>"VA", "Washington - WA"=>"WA", "Washington DC - DC"=>"DC", "West Virginia - WV"=>"WV", "Wisconsin - WI"=>"WI", "Wyoming - WY"=>"WY"
    }
  end

  def get_agents_list
    User.select('id, email').where(role: 'AGENT')
  end
end
