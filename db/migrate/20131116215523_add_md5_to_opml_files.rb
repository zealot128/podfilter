class AddMd5ToOpmlFiles < ActiveRecord::Migration
  def change
    add_column :opml_files, :md5, :string
    add_index :opml_files, :md5, unique: true
  end
end
