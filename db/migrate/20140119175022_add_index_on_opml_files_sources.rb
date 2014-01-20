class AddIndexOnOpmlFilesSources < ActiveRecord::Migration
  def change
    add_index "opml_files_sources", "source_id"
  end
end
