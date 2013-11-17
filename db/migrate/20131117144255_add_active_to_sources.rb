class AddActiveToSources < ActiveRecord::Migration
  def change
    add_column :sources, :active, :boolean
    add_index :sources, :active
  end
end
