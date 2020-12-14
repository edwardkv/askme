class HashtagController < ApplicationController
  before_action :set_hashtag, only: [:show, :edit, :update, :destroy]

  def show
    @questions = @hashtag.questions
  end

  private

  def set_hashtag
    begin
      @hashtag = Hashtag.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      redirect_to root_url, alert: 'Тег не найден'
    end
  end

  def hashtag_params
    params.fetch(:hashtag, {})
  end
end
