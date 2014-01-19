class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.text :title
      t.text :description
      t.string :image
      t.integer :subscriber_count

      t.timestamps
    end
  end
end
