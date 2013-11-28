class AddMediaUrlToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :media_url, :string
  end
end
