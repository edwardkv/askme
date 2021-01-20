class Question < ApplicationRecord
  HASHTAG_REGEXP = /#[[:word:]-]+/
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  has_and_belongs_to_many :hashtags

  #текст вопроса не пустой
  validates :text, presence: true
  #Проверка максимальной длины текста вопроса (максимум 255 символов)
  validates :text, length: { maximum: 255 }

  before_save :set_hashtags
  after_commit :delete_old_hashtags

  def set_hashtags
    self.hashtags = "#{text} #{answer}".downcase.scan(HASHTAG_REGEXP).uniq.map { |ht| Hashtag.find_or_create_by(text: ht) }
  end

  def delete_old_hashtags
    Hashtag.includes(:questions).where(questions: { id: nil }).destroy_all
  end
end

