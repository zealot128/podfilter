class SourcesController < ApplicationController
  load_and_authorize_resource

  def show
    @podcast = @source.podcast
    render 'podcasts/show'
  end

end
