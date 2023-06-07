class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :description
      t.string :path
      t.integer :user_id
      t.boolean :shared

      t.timestamps
    end
  end
end
