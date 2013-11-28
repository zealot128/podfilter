class SourceUpdateWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 1, backtrace: 10, unique: true, queue: :low

  def perform(source_id)
    source=  Source.find(source_id)
    source.full_refresh
  end
end
