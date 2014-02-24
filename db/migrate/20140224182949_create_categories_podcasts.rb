class CreateCategoriesPodcasts < ActiveRecord::Migration
  def change
    create_table :categories_podcasts, :id => false do |t|
      t.references :category, :podcast
    end

    add_index :categories_podcasts, [:category_id, :podcast_id],
      name: "categories_podcasts_index",
      unique: true
  end
end
