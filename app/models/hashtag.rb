class Hashtag < ApplicationRecord
  has_and_belongs_to_many :questions

  validates :text, presence: true, uniqueness: true
end
