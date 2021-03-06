class UsersController < ApplicationController
  before_action :load_user, except: [:index, :create, :new]
  # Проверяем, имеет ли юзер доступ к экшену, делаем это для всех действий, кроме
  # :index, :new, :create, :show — к ним есть доступ у всех, даже у анонимных юзеров.
  before_action :authorize_user, except: [:index, :new, :create, :show]

  def index
    @users = User.all
    #теги c вопросами
    @hashtags = Hashtag.left_joins(:hashtags_questions).
      where.not(hashtags_questions: {hashtag_id: nil}).group(:id).order(:text)
    #все теги
    #@hashtags = Hashtag.all.order(:text)
  end

  def new
    # Если юзер залогинен, отправляем его на главную с сообщением
    redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?

    @user = User.new
  end

  def create
    redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?

    # создаём нового пользователя с параметрами
    @user = User.new(user_params)

    # Сохраняем
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Вы успешно зарегистрированы!'
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
    @questions = @user.questions.order(created_at: :desc)

    @new_question = @user.questions.build

    #счетчики вопросов, ответов
    @questions_count = @questions.count
    @answers_count = @questions.where.not(answer: nil).count
    @without_answered_count = @questions_count - @answers_count
  end

  def destroy
    #удалим пользователя
    @user.destroy

    flash[:success] = "Пользователь удалён!"
    redirect_to root_path
  end

  private

  def authorize_user
    reject_user unless @user == current_user
  end

  def load_user
    begin
      # защищаем от повторной инициализации с помощью ||=
      @user ||= User.find params[:id]
    rescue ActiveRecord::RecordNotFound => e
      redirect_to root_url, alert: 'Пользователь не найден'
    end
  end

  def user_params
    # берём объект params, потребуем у него иметь ключ
    # :user, у него с помощью метода permit разрешаем
    # набор инпутов. Ничего лишнего, кроме них, в пользователя не попадёт
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :name, :username, :avatar_url, :background_color)
  end
end
