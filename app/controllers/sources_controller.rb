class SourcesController < ApplicationController
  load_and_authorize_resource

  def show
    @podcast = @source.podcast
    if @source.redirected_to
      redirect_to [@podcast, @source.redirected_to]
    end
    render 'podcasts/show'
  end

end
