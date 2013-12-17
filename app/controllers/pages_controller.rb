class PagesController < ApplicationController
  before_action :require_login, only: :dashboard
  def index
  end

  def impress
  end

  def dashboard
    @owner = current_user
    @recommended_sources = @owner.recommended_sources.order('weight desc').
      select('sources.*, weight').page(params[:page]).per(10)

  end

  def recommendation_feed
    @owner = Owner.find(params[:owner_id])
    recommended_sources = @owner.recommended_sources.order('weight desc').
      select('sources.*, weight').limit(30)
    @episodes = recommended_sources.map do |r|
      r.episodes.with_file.newest_first.first
    end.compact
    if params.keys.include? "no_torrent"
      @episodes.reject!{|e| e.media_type['torrent']}
    end
    if params[:count] and params[:count].to_i > 0
      @episodes = @episodes.take(params[:count].to_i)
    end

    respond_to do |f|
      f.xml
      f.html { redirect_to format: :xml }
      f.rss  { redirect_to format: :xml }
      f.atom { redirect_to format: :xml }
    end
  end
end
