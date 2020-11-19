class Question < ApplicationRecord

  belongs_to :user

  #текст вопроса не пустой
  validates :text, :user, presence: true




end

