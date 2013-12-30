class ChangeMediaUrlToText < ActiveRecord::Migration
  def change
    change_column :episodes, :media_url, :text
    change_column :episodes, :url, :text
  end
end
