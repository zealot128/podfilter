Feedjira::Feed.add_common_feed_element :"itunes:image", :value => :href, :as => :itunes_image
Feedjira::Feed.add_common_feed_element :"itunes:summary", :as => :itunes_summary
Feedjira::Feed.add_common_feed_elements :"itunes:category", :as => :itunes_categories, :value => :text
Feedjira::Feed.add_common_feed_element :url, :as => :image

Feedjira::Feed.add_common_feed_entry_element   :"feedburner:origEnclosureLink", as: :enclosure_url
# Ifjiraor is not present use author tag on the item
Feedjira::Feed.add_common_feed_entry_element   :"itunes:author", :as => :itunes_author
Feedjira::Feed.add_common_feed_entry_element   :"itunes:block", :as => :itunes_block
Feedjira::Feed.add_common_feed_entry_element   :"itunes:duration", :as => :itunes_duration
Feedjira::Feed.add_common_feed_entry_element   :"itunes:explicit", :as => :itunes_explicit
Feedjira::Feed.add_common_feed_entry_element   :"itunes:keywords", :as => :itunes_keywords
Feedjira::Feed.add_common_feed_entry_element   :"itunes:subtitle", :as => :itunes_subtitle
Feedjira::Feed.add_common_feed_entry_element   :"itunes:image", :value => :href, :as => :itunes_image
Feedjira::Feed.add_common_feed_entry_element   :"itunes:summary", :as => :itunes_summary
Feedjira::Feed.add_common_feed_entry_element   :enclosure, :value => :length, :as => :enclosure_length
Feedjira::Feed.add_common_feed_entry_element   :enclosure, :value => :type, :as => :enclosure_type
Feedjira::Feed.add_common_feed_entry_element   :enclosure, :value => :url, :as => :enclosure_url

Feedjira::Feed.add_common_feed_entry_element 'media:content' , as: :enclosure_url, value: :url


# Ethon.logger = Logger.new('/dev/null')

