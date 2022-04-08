class Post < ApplicationRecord
  belongs_to :user
  has_many :reactions

  validates :body, length: { minimum: 1, maximum: 280 }
end
