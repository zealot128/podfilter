class SimilarPodcasts
  def o_s; @o_s ||= Arel::Table.new(:opml_files_sources); end
  def s; @s   ||= Arel::Table.new(:sources); end
  def c_p; @c_p ||= Arel::Table.new(:categories_podcasts); end
  attr_reader :podcast

  def initialize
    o_s; s; c_p
  end

  def similar(podcast, limit: 10)
    @podcast = podcast
    final = most_listened_other_sources.where(o_s[:source_id].in(sources_similiar_by_category))
    Source.joins("inner join (#{final.to_sql}) a1 on a1.source_id = sources.id").order('a1.count desc').limit(limit * 2).pluck(:podcast_id).uniq.take(limit)
  end

  private

  def sources_similiar_by_category
    s.where(s[:podcast_id].in(most_similar_podcast_by_category)).project(s[:id])
  end

  def most_similar_podcast_by_category
    c_p.
      # project(c_p[:podcast_id], count).
      where(c_p[:category_id].in(categories_of_podcast)).
      group(c_p[:podcast_id]).
      where(c_p[:podcast_id].not_eq(podcast.id)).
      # order('count desc').
      project(c_p[:podcast_id])
  end

  def categories_of_podcast
    c_p.where( c_p[:podcast_id].eq(podcast.id)).project(:category_id)
  end

  def most_listened_other_sources
    o_s.
      project(o_s[:source_id], 'count(*) as count').
      where(o_s[:opml_file_id].in(opml_files_listening_to_podcast)).
      group(o_s[:source_id]).
      where(o_s[:source_id].not_in(source_ids_of_podcast)).
      order('count desc')
  end

  def opml_files_listening_to_podcast
    o_s.where( o_s[:source_id].in(source_ids_of_podcast)).project(:opml_file_id)
  end
  def source_ids_of_podcast
    s.project(:id).where(s[:podcast_id].eq(podcast.id))
  end
end
