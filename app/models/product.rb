class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: true
  validates_length_of :title, minimum: 10, message: "must have at least 10 characters."
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
end
