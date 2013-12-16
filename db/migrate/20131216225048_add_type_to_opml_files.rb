class AddTypeToOpmlFiles < ActiveRecord::Migration
  def change
    add_column :opml_files, :type, :string
    add_index :opml_files, :type
    execute 'update opml_files set type=\'OpmlFile\';'
  end
end
