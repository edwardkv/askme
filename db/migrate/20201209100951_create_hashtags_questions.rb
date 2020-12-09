class CreateHashtagsQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :hashtags_questions do |t|
      t.references :question
      t.references :hashtag
    end
  end
end
