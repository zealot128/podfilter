class AddIndicesToSources < ActiveRecord::Migration
  def change
    add_index :episodes, :pubdate
    add_index :sources, :offline
  end
end
