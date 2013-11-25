class OpmlFilesSource < ActiveRecord::Base
  belongs_to :opml_file
  belongs_to :source, counter_cache: :owners_count
end
