class SimilarityCalculation

  def initialize(base_user)
    @user = base_user
  end

  def refresh
    @user.recommendations.delete_all
    recommendations(top_k: 5, count: 100).each do |id, weight|
      r = @user.recommendations.build
      r.weight = weight
      r.source_id = id
      r.save!
    end
  end

  def self.refresh_all
    Owner.joins(:opml_files).pluck(:id).each do |owner_id|
      SimilarityWorker.perform_async(owner_id)
    end
  end

  def distance(podcast_ids)
    in_common = my_podcasts & podcast_ids
    in_common.count
  end

  def recommendations(top_k: 8, count: 15)
    users_with_distances = other_users.map do |user|
      ids = podcast_ids(user)
      {
        user: user.id,
        podcast_ids: ids,
        distance: distance(ids)
      }
    end
    similars = users_with_distances.sort_by{|i| i[:distance] }.take(top_k)
    possible_podcast_ids = similars.map{|i| i[:podcast_ids]}.flatten - my_podcasts
    podcast_ids_with_counts = possible_podcast_ids.group_by{|i|i}.map{|id,ids| [id, ids.count] }
    podcast_ids_with_counts.sort_by{|id,c| -c}.take(count)
  end

  private

  def my_podcasts
    @my ||= podcast_ids(@user)
  end

  def other_users
    Owner.where('id != ?', @user.id)
  end

  def podcast_ids(user)
    user.source_ids
  end

end
