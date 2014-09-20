class ChangeRequests::MergeRequest < ChangeRequest
  store_accessor :payload, :source_id
  store_accessor :payload, :target_id
  validates :source_id, presence: true
  validates :target_id, presence: true

  def prefill(params)
    self.source_id = params[:source_id]
    self.target_id = params[:target_id]
  end

  def to_s
    "Merging von #{source.url} in #{target.url}"
  end

  def apply!
    Source.transaction do
      source.podcast.destroy
      source.update_attribute :podcast_id,  target.podcast_id
      super
    end
  end

  def source
    @source ||= Source.find(self.source_id)
  end

  def target
    @target ||= Source.find(self.target_id)
  end

  def self.permit(params)
    params.require(:change_request).permit(:source_id, :target_id).merge(super)
  end

end
