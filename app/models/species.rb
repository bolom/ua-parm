require "down"

class Species < ApplicationRecord
  belongs_to :genus, optional: true
  has_many_attached :images

   def grab_image(url)
     image = Down.download(url)
     self.images.attach(io: image, filename: "image.jpg")
  end
end
