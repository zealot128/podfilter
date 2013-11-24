class AddNameToOpmlFiles < ActiveRecord::Migration
  def change
    add_column :opml_files, :name, :string
  end
end
