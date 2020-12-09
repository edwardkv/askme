module ApplicationHelper
  HASHTAG_REGEXP=/#[[:word:]-]+/
  # Этот метод возвращает ссылку на аватарку пользователя, если она у него есть.
  # Или ссылку на дефолтную аватарку, которую положим в app/assets/images
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  def question_author(author)
    if author.present?
      link_to "@#{author.username}", user_path(author)
    else
      "неизвестен"
    end
  end

  #склонятор
  def inclination(number, one, few, many)
    #если не число
    return "" if number.nil? || !number.is_a?(Numeric)

    #Рассчитываем остаток от деления на 10 и 100
    ostatok = number % 10
    ostatok_100 = number % 100

    # Проверяем, входит ли остаток от деления на 100 в период 11..14
    return many if (11..14).include?(ostatok_100)

    return one if ostatok == 1

    return few if (2..4).include?(ostatok)

    return many if  ostatok >= 5 || ostatok == 0
  end

  def find_hashtags(question)
    hashtags = "#{question.text}  #{question.answer}".downcase.scan(HASHTAG_REGEXP).uniq
  end
end
