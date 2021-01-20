# Приложение askme

### Описание
Приложение позволяет получить ответы на вопросы.

Ruby version 2.7

Rails version 6.0.3

Демо приложения https://edwardask.herokuapp.com/

###Установка
Склонировать ```git clone git@github.com:edwardkv/askme.git```

Перед запуском выполнить ```bundle && bundle exec rake db:migrate``` ```yarn```

Прописать в переменные окружения ключи для капчи RECAPTCHA_ASKME_PUBLIC_KEY, RECAPTCHA_ASKME_PRIVATE_KEY
Для этого переименовать файл ```.env.example``` в ```.env``` и пропиcать значения.

