class ApplicationController < ActionController::Base
  HASHTAG_REGEXP = /#[[:word:]-]+/
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def reject_user
    redirect_to root_path, alert: 'Доступ запрещен!'
  end

  def find_hashtag(string)
    hashtags = string.scan(HASHTAG_REGEXP)
  end
end
