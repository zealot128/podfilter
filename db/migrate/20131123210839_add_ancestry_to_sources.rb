class AddAncestryToSources < ActiveRecord::Migration
  def change
    add_column :sources, :ancestry, :string
    add_index :sources, :ancestry
  end
end
