class PodcastsController < ApplicationController
  def index
    sql = Podcast.page(params[:page]).per(30)
    if params[:q]
      sql = sql.search(params[:q])
    end
    if params[:category_id]
      @category = Category.find(params[:category_id])
      sql = sql.where('(select categories_podcasts.podcast_id from categories_podcasts where categories_podcasts.podcast_id = podcasts.id and categories_podcasts.category_id = ? limit 1) is not null', @category)
      sql = sql.order('subscriber_count desc')
      @title = "Kategorie: #{@category.translated_name}"
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
