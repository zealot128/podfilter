class DuplicateWorker
  include Sidekiq::Worker

  sidekiq_options backtrace: 10, queue: :low
  def perform
    DuplicateFinder.cronjob
  end
end
