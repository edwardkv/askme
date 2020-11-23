module ApplicationHelper
  # Этот метод возвращает ссылку на аватарку пользователя, если она у него есть.
  # Или ссылку на дефолтную аватарку, которую положим в app/assets/images
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.jpg'
    end
  end

  def inclination(number, one, few, many)
    return number = 0 if number.nil? || !number.is_a?(Numeric)

    #Рассчитываем остаток от деления на 10 и 100
    ostatok = number % 10
    ostatok_100 = number % 100

    # Проверяем, входит ли остаток от деления на 100 в период 11..14
    return many if (11..14).include?(ostatok_100)

    return one if ostatok == 1

    return few if (2..4).include?(ostatok)

    return many if  ostatok >= 5 || ostatok == 0

  end
end
