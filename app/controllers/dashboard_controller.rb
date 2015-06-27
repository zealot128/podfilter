class DashboardController < ApplicationController
  before_action :require_login, only: :dashboard

  def index
    @owner = current_user
    if params[:page].present? and params[:page].to_i > 1
      render "recommendations_only"
    end
  end

  private

  def recommended_podcasts
    @_recommended_podcasts ||= @owner.recommended_podcasts.order('weight desc, subscriber_count desc, id asc').
      select('podcasts.*, weight').page(params[:page]).per(10)
  end
  helper_method :recommended_podcasts

  def podlove_data
    {
      title: "Podfilter Empfehlungsfeed für #{current_user.id}",
      subtitle: 'Aus den besten Empfehlungen die neusten Podcast-Episoden',
      description: 'Aus den besten Empfehlungen die neusten Podcast-Episoden',
      cover: '',
      feeds: [
        {
          type: 'audio',
          format: 'mp3',
          url: recommendation_feed_url(owner_id: current_user, no_torrent: 1)
        },
        {
          type: 'audio',
          format: 'x-bittorrent',
          url: recommendation_feed_url(owner_id: current_user)
        }
      ]
    }
  end
  helper_method :podlove_data
end
