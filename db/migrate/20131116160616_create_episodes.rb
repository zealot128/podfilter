class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :image
      t.datetime :pubdate
      t.string :guid
      t.belongs_to :source, index: true

      t.timestamps
    end
    add_index :episodes, [:source_id, :guid], unique: true, name: 'episode_uniq_guid'
  end
end
