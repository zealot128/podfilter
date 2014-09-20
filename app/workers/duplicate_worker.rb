class DuplicateWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: 10, unique: true, queue: :low
  def perform
    DuplicateFinder.cronjob
  end
end
