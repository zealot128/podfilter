class AddOfflineToSources < ActiveRecord::Migration
  def change
    add_column :sources, :offline, :boolean
  end
end
