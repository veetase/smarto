class Splash < ActiveRecord::Base
  # this must declared before validates
  has_attached_file :picture,
                    path: ":class/:attachment/:id/:basename.:extension",
                    default_url: "http://7xj6xc.com2.z0.glb.qiniucdn.com/assets/static_page/dou-775ccb20ab5271a0fef07789722f7eaf.jpg"

  # validates :name, :description, :url, :picture, presence: true
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  scope :active, lambda{where("begin_at <= ? AND end_at >= ?", Time.now, Time.now)}

  def picture_url
    self.picture.url
  end
end
