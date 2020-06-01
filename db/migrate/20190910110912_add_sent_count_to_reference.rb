class AddSentCountToReference < ActiveRecord::Migration[5.0]
  def change
    add_column :references, :email_sent_count, :integer
  end
end
