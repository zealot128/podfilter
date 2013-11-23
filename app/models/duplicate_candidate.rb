class DuplicateCandidate < ActiveRecord::Base
  before_save do
    self.md5 = Digest::MD5.hexdigest(ids.sort.join(','))
  end

  def sources
    Source.where(id: ids)
  end
end
