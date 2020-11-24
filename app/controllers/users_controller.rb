class UsersController < ApplicationController
  before_action :load_user, except: [:index, :create, :new]

  def index
    # Создаём массив из двух болванок пользователей. Вызываем метод # User.new, который создает модель, не записывая её в базу.
    # У каждого юзера мы прописали id, чтобы сымитировать реальную
    # ситуацию – иначе не будет работать хелпер путей
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    # создаём нового пользователя с параметрами
    @user = User.new(user_params)

    # Сохраняем
    if @user.save
      redirect_to root_url, notice: 'Пользователь успешно зарегистрирован!'
    else
      # Если не удалось по какой-то причине сохранить пользователя, то используем метод render (не redirect!),
      # который заново рисует шаблон, и название шаблона
      render 'new'
    end
  end

  def edit
  end

  def update
    # пытаемся обновить юзера
    if @user.update(user_params)
      # Если получилось, отправляем пользователя на его страницу с сообщением
      redirect_to user_path(@user), notice: 'Данные обновлены'
    else
      # Если не получилось, как и в create, рисуем страницу редактирования
      # пользователя со списком ошибок
      render 'edit'
    end
  end

  def show
    @questions = @user.questions.order(create_at: :desc)
    @questions_count = @questions.count

    @new_question = @user.questions.build
  end

  private

  def load_user
    # защищаем от повторной инициализации с помощью ||=
    @user ||= User.find params[:id]
  end

  def user_params
    # берём объект params, потребуем у него иметь ключ
    # :user, у него с помощью метода permit разрешаем
    # набор инпутов. Ничего лишнего, кроме них, в пользователя не попадёт
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :name, :username, :avatar_url)
  end
end
