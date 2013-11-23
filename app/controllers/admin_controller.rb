class AdminController < ApplicationController
  authorize_resource class: false

  def duplicates
    @duplicates = DuplicateCandidate.limit(20)
  end

  def merge

    sources = Source.where(id: params[:sources])
    if sources.count < 2
      raise ArgumentError
    end
    parent = sources.shift
    sources.each do |s|
      s.parent = parent
      s.save validate: false
    end
    redirect_back_or_dashboard
  end
end
