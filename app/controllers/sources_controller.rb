class SourcesController < ApplicationController
  load_and_authorize_resource

  def show
    if @source.redirected_to
      redirect_to [@source.redirected_to.podcast, @source.redirected_to]
      return
    end
    @podcast = @source.podcast
    render 'podcasts/show'
  end

end
