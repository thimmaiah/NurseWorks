class CreateCqcRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :cqc_records do |t|
      t.string :name
      t.string :aka
      t.string :address
      t.string :postcode
      t.string :phone
      t.string :website
      t.text :service_types
      t.text :services
      t.string :local_authority
      t.string :region
      t.string :cqc_url
      t.string :cqc_location

      t.timestamps
    end
    add_index :cqc_records, :postcode
    add_index :cqc_records, :cqc_location
  end
end
