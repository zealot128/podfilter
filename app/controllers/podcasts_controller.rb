class PodcastsController < ApplicationController
  def index
    sql = Podcast.page(params[:page]).per(30)
    if params[:q]
      sql = sql.search(params[:q])
    end
    case params[:order]
    when :most
      sql = sql.order('subscriber_count desc')
      @title = 'Beliebteste Podcasts'
    when :recent
      sql = FastQueries.recently_updated_podcasts(limit: 200)
      @title = 'Kürzlich aktualisiert'
    else
      @title = 'Podcasts suchen'
    end
    @podcasts = sql
  end

  def show
    @podcast = Podcast.where(id: params[:id]).includes(:sources).first!
  end
end
