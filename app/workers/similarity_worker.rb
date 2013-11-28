class SimilarityWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5, backtrace: 10, unique: true, queue: :important

  def perform(owner_id)
    owner = Owner.find(owner_id)
    SimilarityCalculation.new(owner).refresh
  end
end
