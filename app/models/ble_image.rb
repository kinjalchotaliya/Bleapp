class BleImage < ActiveRecord::Base
  belongs_to :bleeapp

  has_attached_file :image, styles: { medium: "500x500>", thumb: "100x100>" }, default_url: "/assets/no-property-image.jpg"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  before_create :randomize_file_name

private

  def randomize_file_name
    extension = File.extname(image_file_name).downcase
    name = File.basename(image_file_name, File.extname(image_file_name));
    self.image.instance_write(:file_name, "#{name}_#{Time.now.to_i + rand(1..50)}#{extension}")
  end
end
