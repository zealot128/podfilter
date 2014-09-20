class AdminController < ApplicationController
  authorize_resource class: false

  def duplicates
    @duplicates = DuplicateFinder.get_dupegroups
  end

  def merge
    sources = Source.where(id: params[:sources])
    # TODO
    redirect_back_or_dashboard
  end
end
