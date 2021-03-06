class SourcesController < ApplicationController
  load_and_authorize_resource

  def show
    if @source.redirected_to
      redirect_to [@source.redirected_to.podcast, @source.redirected_to]
      return
    end
    @page = [1, params[:page].to_i].max
    @episodes = @source.episodes.order('pubdate desc').page(@page).per(100)
    @podcast = @source.podcast
    if @podcast.nil?
      render 'show'
    else
      render 'podcasts/show'
    end
  end

end
