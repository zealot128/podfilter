class CreateOpmlFilesSources < ActiveRecord::Migration
  def change
    create_table :opml_files_sources, :id => false do |t|
      t.references :opml_file, :source
    end

    add_index :opml_files_sources, [:opml_file_id, :source_id],
      name: "opml_files_sources_index",
      unique: true
  end
end
