class AddIndexToHashtagsQuestions < ActiveRecord::Migration[6.0]
  def change
    add_index :hashtags_questions, [:question_id, :hashtag_id], unique: true
  end
end
