class AddPodcastIdToSources < ActiveRecord::Migration
  def change
    add_column :sources, :podcast_id, :integer
    add_index :sources, :podcast_id
  end
end
