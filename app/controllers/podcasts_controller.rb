class PodcastsController < ApplicationController
  def index
    sql = Podcast.page(params[:page]).per(30)
    if params[:q]
      sql = sql.search(params[:q])
    end
    @podcasts = sql
  end

  def show
    @podcast = Podcast.where(id: params[:id]).includes(:sources).first!
  end
end
