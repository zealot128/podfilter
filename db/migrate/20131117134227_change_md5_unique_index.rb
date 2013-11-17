class ChangeMd5UniqueIndex < ActiveRecord::Migration
  def change
    remove_index :opml_files, :md5
    add_index :opml_files, [:md5, :owner_id]
  end
end
