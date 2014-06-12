class PagesController < ApplicationController
  before_action :require_login, only: :dashboard
  def index
    @most = Podcast.order('subscriber_count desc').limit(20).includes(:sources)
  end

  def impress
  end

  def dashboard
    @owner = current_user
    @recommended_podcasts = @owner.recommended_podcasts.order('weight desc').
      select('podcasts.*, weight').page(params[:page]).per(10)

  end

  def recommendation_feed
    @owner = Owner.find(params[:owner_id])
    recommended_podcasts = @owner.recommended_podcasts.order('weight desc').
      select('podcasts.*, weight').limit(100)

    sources = recommended_podcasts.map do |r|
      sql = r.sources.order('owners_count desc')
      sql.first
    end.compact
    @episodes = sources.map do |source|
      sql = source.episodes.with_file.newest_first
      if params.keys.include? 'no_torrent'
        sql = sql.where('media_url not like ?', '%torrent%')
      end
      sql.first
    end.compact

    limit = (params[:count] || 30).to_i
    @episodes = @episodes.take(limit)

    respond_to do |f|
      f.xml
      f.html { redirect_to format: :xml }
      f.rss  { redirect_to format: :xml }
      f.atom { redirect_to format: :xml }
    end
  end

  def not_found
    render status: :not_found, layout: false, text: 'Page not found', formats: [:html]
  end
end
