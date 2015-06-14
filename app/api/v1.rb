class V1 < Grape::API
  include LoggingApi

  content_type :csv, 'text/csv; charset=iso-8859-1; header=present'
  default_format :json
  formatter :csv, CsvFormatter

  before do
    @owner = Owner.where(api_key: params[:api_key]).first
    if !@owner
      error!({error: 'Api-Key unauthorized'}, 403)
    end
  end

  resource :subscribers do
    desc 'Liste aller (pseudonymisierten) Abonnenten und alle Podcasts, die diese hören, als flache Liste. Akzeptiert JSON oder CSV.'
    params do
      requires :api_key, type: String
    end
    get 'flat_subscriptions' do
      sql = Owner.joins(:opml_files => {:sources => :podcast }).
        where('opml_files.type != ?', 'IgnoreFile').
        order('owners.id, podcast_id').
        pluck('owners.id, podcasts.id as podcast_id, podcasts.title as podcast_title, array(select categories.name from categories inner join categories_podcasts on categories_podcasts.category_id = categories.id where categories_podcasts.podcast_id = podcasts.id) as categories')

      headline = [ :owner_id, :podcast_id, :podcast_title, :podcast_categories ]
      sql.map do |a|
        headline.zip(a).to_h
      end
    end
  end
end
