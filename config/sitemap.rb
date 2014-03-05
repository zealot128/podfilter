# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.podfilter.de"

SitemapGenerator::Sitemap.create do
  add '/browse/most-popular', priority: 0.7, changefreq: 'weekly'
  add '/', priority: 1.0, changefreq: 'daily'

  Category.find_each do |category|
    add category_path(category), priority: '0.7', changefreq: 'weekly'
  end
  Podcast.active.where(language: 'german').find_each do |podcast|
    add podcast_path(podcast), priority: '0.5', changefreq: 'weekly', lastmod: podcast.updated_at
  end
  Source.find_each do |source|
    next if source.podcast_id.nil?
    add podcast_source_path(source.podcast,source), priority: '0.2', changefreq: source.active? ? 'daily' : 'monthly', lastmod: source.updated_at
  end
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
