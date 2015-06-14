class V1 < Grape::API
  include LoggingApi

  default_format :json

  resource :subscribers do
    desc 'Liste aller (pseudonymisierten) Abonnenten und alle Podcasts, die diese hören als flache Liste'
    get 'flat_subscriptions' do


    end
  end
end
