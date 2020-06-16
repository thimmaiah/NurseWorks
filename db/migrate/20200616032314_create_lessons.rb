class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
      t.text :title
      t.string :youtube_link
      t.text :description
      t.integer :min_nq_score
      t.integer :max_nq_score
      t.integer :quiz_id

      t.timestamps
    end
  end
end
