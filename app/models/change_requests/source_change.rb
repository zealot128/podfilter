class ChangeRequests::SourceChange < ChangeRequest
  store_accessor :payload, :source_id
  store_accessor :payload, :action
  store_accessor :payload, :url

  validates :action, inclusion: { in: %w[delete change]}
  validates :source_id, presence: true
  validates :url, presence: true, if: ->(r){r.action == 'change' }

  def prefill(params)
    self.source_id = params[:source_id]
    self.url = source.url
  end

  def to_s
    "#{action == 'change' ? 'Änderung' : 'Löschung'} einer Quelle (#{source.try(:url) || '??'})"
  end

  def apply!
    source = self.source
    if action == 'change'
      source.url = self.url
      source.save!
      SourceUpdateWorker.perform_async(source_id)
    elsif action == 'delete'
      source.destroy
    end
    super
  end

  def source
    @source ||= Source.find(self.source_id) rescue nil
  end

  def self.permit(params)
    params.require(:change_request).permit(:source_id, :url, :action).merge(super)
  end
end
