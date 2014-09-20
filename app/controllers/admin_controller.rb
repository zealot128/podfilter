class AdminController < ApplicationController
  authorize_resource class: false

  def duplicates
    @duplicates = DuplicateFinder.get_dupegroups.shuffle.take(20).map do |source_ids|
      Podcast.where id: Source.where(id: source_ids).select(:podcast_id)
    end
  end

  def merge
    others = Podcast.where(id: params[:podcast_ids])
    main = others.find(params[:target_id])
    main.merge(others)
    @id = params[:html_id]
  end
end
