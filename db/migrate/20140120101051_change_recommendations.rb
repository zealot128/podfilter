class ChangeRecommendations < ActiveRecord::Migration
  def change
    execute 'delete from recommendations'
    remove_column :recommendations, :source_id
    add_column :recommendations, :podcast_id, :integer

    add_index "recommendations", ["owner_id", "podcast_id"], name: "recommendations_owner_podcast", unique: true, using: :btree

  end
end
