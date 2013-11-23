class AdminController < ApplicationController
  authorize_resource class: false

  def duplicates
    @duplicates = DuplicateCandidate.limit(20)
  end

  def merge
    sources = Source.where(id: params[:sources])
    Source.merge_sources sources
    redirect_back_or_dashboard
  end
end
