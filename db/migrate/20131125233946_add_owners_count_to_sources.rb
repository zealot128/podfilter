class AddOwnersCountToSources < ActiveRecord::Migration
  def change
    add_column :sources, :owners_count, :integer
    add_index :sources, :owners_count
  end
end
