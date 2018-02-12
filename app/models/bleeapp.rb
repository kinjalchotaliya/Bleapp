class Bleeapp < ActiveRecord::Base
  has_many :visited_bleapps, dependent: :destroy
  has_many :ble_images, dependent: :destroy

  belongs_to :property
  belongs_to :beacon

  validates :title, presence: true
  validates :tags, presence: true

  has_attached_file :image, styles: { medium: "500x500>", thumb: "100x100>" }, default_url: "/assets/no-property-image.jpg"
  has_attached_file :audio, processors: [ :audio_bit_rate_processor ], styles: { original: {} }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :audio, content_type: "audio/mpeg"
  validates_attachment_size :audio, less_than: 15.megabytes

  is_impressionable
end
