class AddltypeToLesson < ActiveRecord::Migration[5.2]
  def change
    rename_column :lessons, :youtube_link, :link
    add_column :lessons, :link_type, :string
  end
end
