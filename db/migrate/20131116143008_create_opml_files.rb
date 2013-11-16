class CreateOpmlFiles < ActiveRecord::Migration
  def change
    create_table :opml_files do |t|
      t.text :source
      t.belongs_to :owner, index: true

      t.timestamps
    end
  end
end
