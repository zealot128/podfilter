class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :url
      t.string :title
      t.text :description

      t.timestamps
    end
    add_index :sources, :url, unique: true
  end
end
