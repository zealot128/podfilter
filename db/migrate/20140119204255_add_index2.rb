class AddIndex2 < ActiveRecord::Migration
  def change
    add_index :sources, [:podcast_id, :id]
    add_index :episodes, [ :source_id, :pubdate]
    add_index :episodes, :created_at
    add_index :episodes, [:source_id, :created_at]
    add_index :episodes, [:created_at, :source_id]
  end
end
