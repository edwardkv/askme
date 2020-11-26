require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new
  EMAIL_REGEXP = /[\w.+-]+@[\w.-]+\.[a-zA-Z]{2,4}/
  USERNAME_REGEXP = /\A\w+\z/
  COLOR_REGEXP = /\A\#[\da-fA-Z]{6}\z/
  DEFAULT_COLOR = "#106a65"

  attr_accessor :password

  has_many :questions

  #проверка что email и username не пустые
  validates :email, :username, presence: true
  # проверка формата электронной почты пользователя, уникальный email(без учета регистра)
  validates :email, format: { with: EMAIL_REGEXP }, uniqueness: true

  # проверка формата юзернейма пользователя (только латинские буквы, цифры, и знак _) и на уникальность(без учета регистра)
  # проверка максимальной длины юзернейма пользователя (не больше 40 символов)
  validates :username, format: { with: USERNAME_REGEXP }, uniqueness: true, length: { maximum: 40 }

  # валидация будет проходить только при создании нового юзера
  validates :password, presence: true, on: :create

  # подтверждения пароля
  validates :password, confirmation: true

  validates :background_color, format: { with: COLOR_REGEXP }

  validates :avatar_url, format: { with: URI.regexp }, allow_blank: true

  # перед валидацией переводим username в нижний регистр и т.п.
  before_validation :normalize_user
  # шифрование пароля
  before_save :encrypt_password

  # Основной метод для аутентификации юзера (логина). Проверяет email и пароль,
  # если пользователь с такой комбинацией есть в базе, возвращает этого
  # пользователя. Если нет — возвращает nil.
  def self.authenticate(email, password)
    # Сперва находим кандидата по email
    email&.downcase!
    user = find_by(email: email)

    # Если пользователь не найден, возвращает nil
    return nil unless user.present?

    # Формируем хэш пароля из того, что передали в метод
    hashed_password = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST)
    )

    # Обратите внимание: сравнивается password_hash, а оригинальный пароль так
    # никогда и не сохраняется нигде. Если пароли совпали, возвращаем
    # пользователя.
    return user if user.password_hash == hashed_password

    # Иначе, возвращаем nil
    nil
  end

  # Служебный метод, преобразующий бинарную строку в шестнадцатиричный формат, для удобства хранения.
  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  private

  #в базу username пользователей попадали только в нижнем регистре
  #email в нижнем регистре
  def normalize_user
    username&.downcase!
    email&.downcase!

    # присваиваем цвет по умолчанию, если в поле background_color пусто
    self.background_color = DEFAULT_COLOR if self.background_color.nil?
  end

  def encrypt_password
    if password.present?
      # Создаем т.н. «соль» — случайная строка, усложняющая задачу хакерам по
      # взлому пароля, даже если у них окажется наша БД.
      #У каждого юзера своя «соль», это значит, что если подобрать перебором пароль
      # одного юзера, нельзя разгадать, по какому принципу
      # зашифрованы пароли остальных пользователей
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      # Создаем хэш пароля — длинная уникальная строка, из которой невозможно
      # восстановить исходный пароль. Однако, если правильный пароль у нас есть,
      # мы легко можем получить такую же строку и сравнить её с той, что в базе.
      self.password_hash = User.hash_to_string(
          OpenSSL::PKCS5.pbkdf2_hmac(password, password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
      # Оба поля попадут в базу при сохранении (save).
    end
  end
end
