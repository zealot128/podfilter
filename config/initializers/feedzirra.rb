Feedzirra::Feed.add_common_feed_element :"itunes:image", :value => :href, :as => :itunes_image
Feedzirra::Feed.add_common_feed_element :"itunes:summary", :as => :itunes_summary
Feedzirra::Feed.add_common_feed_elements :"itunes:category", :as => :itunes_categories, :value => :text
Feedzirra::Feed.add_common_feed_element :url, :as => :image

Feedzirra::Feed.add_common_feed_entry_element   :"feedburner:origEnclosureLink", as: :enclosure_url
# If author is not present use author tag on the item
Feedzirra::Feed.add_common_feed_entry_element   :"itunes:author", :as => :itunes_author
Feedzirra::Feed.add_common_feed_entry_element   :"itunes:block", :as => :itunes_block
Feedzirra::Feed.add_common_feed_entry_element   :"itunes:duration", :as => :itunes_duration
Feedzirra::Feed.add_common_feed_entry_element   :"itunes:explicit", :as => :itunes_explicit
Feedzirra::Feed.add_common_feed_entry_element   :"itunes:keywords", :as => :itunes_keywords
Feedzirra::Feed.add_common_feed_entry_element   :"itunes:subtitle", :as => :itunes_subtitle
Feedzirra::Feed.add_common_feed_entry_element   :"itunes:image", :value => :href, :as => :itunes_image
Feedzirra::Feed.add_common_feed_entry_element   :"itunes:summary", :as => :itunes_summary
Feedzirra::Feed.add_common_feed_entry_element   :enclosure, :value => :length, :as => :enclosure_length
Feedzirra::Feed.add_common_feed_entry_element   :enclosure, :value => :type, :as => :enclosure_type
Feedzirra::Feed.add_common_feed_entry_element   :enclosure, :value => :url, :as => :enclosure_url

Feedzirra::Feed.add_common_feed_entry_element 'media:content' , as: :enclosure_url, value: :url


# Ethon.logger = Logger.new('/dev/null')

