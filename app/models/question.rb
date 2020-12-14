class Question < ApplicationRecord
  HASHTAG_REGEXP = /#[[:word:]-]+/
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_and_belongs_to_many :hashtags, join_table: :hashtags_questions, dependent: :destroy

  #текст вопроса не пустой
  validates :text, presence: true
  #Проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }

  after_save :add_hashtags

  def add_hashtags
    hashtags_to_add = find_hashtags - hashtags.collect(&:text)
    hashtags_to_delete = hashtags.collect(&:text) - find_hashtags

    Hashtag.create!(self, hashtags_to_add)
    Hashtag.clear!(self, hashtags_to_delete)
  end

  def find_hashtags
    "#{text} #{answer}".downcase.scan(HASHTAG_REGEXP).uniq
  end
end

