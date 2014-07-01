class ChangeRequests::NewPodcast < ChangeRequest
  store_accessor :payload, :url
  store_accessor :payload, :podcast_id

  validates :url, presence: true, format: { with: %r{\Ahttps?://} }
  validate do
    if Source.where(url: url).first
      errors.add :url, 'URL bereits vorhanden'
    end
  end

  def prefill(params)
    if params[:podcast_id]
      self.podcast_id = params[:podcast_id]
    end
  end

  def to_s
    base = "Hinzufügen einer neuen Quelle (#{url})"
    if podcast.present?
      base += " zu #{podcast.title}"
    end
    base
  end

  def podcast
    if podcast_id.present?
      @podcast ||= Podcast.find(podcast_id)
    end
  end

  def apply!
    source = Source.new url: url
    if podcast
      source.podcast_id = podcast.id
    end
    source.save!
    SourceUpdateWorker.perform_async(source.id)
    super
  end

  def self.permit(params)
    params.require(:change_request).permit(:url, :podcast_id).merge(super)
  end
end
