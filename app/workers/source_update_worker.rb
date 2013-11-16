class SourceUpdateWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 5, backtrace: 10, unique: true


  def perform(source_id)
    source=  Source.find(source_id)
    if source.description.blank?
      source.fetch_meta_information
    end
    source.update_entries
  end
end
