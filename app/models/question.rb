class Question < ApplicationRecord
  belongs_to :user

  #текст вопроса не пустой
  validates :text, presence: true
  #Проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }
end

