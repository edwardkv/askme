class HashtagController < ApplicationController
  before_action :set_hashtag, only: [:show, :edit, :update, :destroy]

  def show
    @questions = @hashtag.questions
  end

  private

  def set_hashtag
    @hashtag = Hashtag.find(params[:id])
  end

  def hashtag_params
    params.fetch(:hashtag, {})
  end
end
