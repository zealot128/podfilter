class AddHasMediaToSources < ActiveRecord::Migration
  def change
    add_column :sources, :has_media, :boolean
    add_index :sources, :has_media
  end
end
