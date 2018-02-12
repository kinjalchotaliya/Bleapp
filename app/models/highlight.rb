class Highlight < ActiveRecord::Base
  belongs_to :property
  belongs_to :user
  has_attached_file :image, styles: { medium: "500x500>", thumb: "100x100>" }, default_url: "/assets/no_highlight_image.jpg"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  is_impressionable
  before_create :randomize_file_name

private

  def randomize_file_name
    if self.image.present?
      extension = File.extname(image_file_name).downcase
      name = File.basename(image_file_name, File.extname(image_file_name));
      self.image.instance_write(:file_name, "#{name}_#{Time.now.to_i + rand(1..50)}#{extension}")
    end
  end
end
