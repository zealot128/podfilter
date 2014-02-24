class ItunesCategories

  CATEGORIES = {
    "Arts" => 'Arts',
    "Design" => 'Arts',
    "Fashion & Beauty" => 'Arts',
    "Food" => 'Arts',
    "Literature" => 'Arts',
    "Performing Arts" => 'Arts',
    "Visual Arts" => 'Arts',

    "Business" => 'Business',
    "Business News" => 'Business',
    "Careers" => 'Business',
    "Investing" => 'Business',
    "Management & Marketing" => 'Business',
    "Shopping" => 'Business',

    "Comedy" => 'Comedy',

    "Education" => 'Education',
    "Education Technology" => 'Education',
    "Higher Education" => 'Education',
    "K-12" => 'Education',
    "Language Courses" => 'Education',
    "Training" => 'Education',

    "Games & Hobbies" => 'Games & Hobbies',
    "Automotive" => 'Games & Hobbies',
    "Aviation" => 'Games & Hobbies',
    "Hobbies" => 'Games & Hobbies',
    "Other Games" => 'Games & Hobbies',
    "Video Games" => 'Games & Hobbies',

    "Government & Organizations" => 'Government & Organizations',
    "Local" => 'Government & Organizations',
    "National" => 'Government & Organizations',
    "Non-Profit" => 'Government & Organizations',
    "Regional" => 'Government & Organizations',

    "Health" => 'Health',
    "Alternative Health" => 'Health',
    "Fitness & Nutrition" => 'Health',
    "Self-Help" => 'Health',
    "Sexuality" => 'Health',

    "Kids & Family" => 'Kids & Family',
    "Music" => 'Kids & Family',
    "News & Politics" => 'Kids & Family',

    "Religion & Spirituality" => 'Religion & Spirituality',
    "Buddhism" => 'Religion & Spirituality',
    "Christianity" => 'Religion & Spirituality',
    "Hinduism" => 'Religion & Spirituality',
    "Islam" => 'Religion & Spirituality',
    "Judaism" => 'Religion & Spirituality',
    "Other" => 'Religion & Spirituality',
    "Spirituality" => 'Religion & Spirituality',

    "Science & Medicine" => 'Science & Medicine',
    "Medicine" => 'Science & Medicine',
    "Natural Sciences" => 'Science & Medicine',
    "Social Sciences" => 'Science & Medicine',

    "Society & Culture" => 'Society & Culture',
    "History" => 'Society & Culture',
    "Personal Journals" => 'Society & Culture',
    "Philosophy" => 'Society & Culture',
    "Places & Travel" => 'Society & Culture',

    "Sports & Recreation" => 'Sports & Recreation',
    "Amateur" => 'Sports & Recreation',
    "College & High School" => 'Sports & Recreation',
    "Outdoor" => 'Sports & Recreation',
    "Professional" => 'Sports & Recreation',

    "Technology" => 'Technology',
    "Gadgets" => 'Technology',
    "Tech News" => 'Technology',
    "Podcasting" => 'Technology',
    "Software How-To" => 'Technology',

    "TV & Film" => 'TV & Film',
  }

  def self.categories(category_list)
    categories = []
    category_list.each do |item|
      item.strip!
      if CATEGORIES[item]
        categories += [item, CATEGORIES[item] ]
      end
    end
    Category.where(name: categories.uniq)
  end

  def self.categories_match(podcast, feed)
    if feed.itunes_categories.present?
      podcast.itunes_category_list = feed.itunes_categories
      podcast.categories = categories(feed.itunes_categories)
      podcast.save
    else
      # matching
    end
  end
end
