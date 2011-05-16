require 'rss/1.0'
require 'rss/2.0'

class Feed < ActiveRecord::Base
  validates :url, :name, :presence => true

  def self.save_all_new_torrent_data
    Feed.download_all_torrent_data.each do |rss_torrent|
      torrent = Torrent.find_or_initialize_by_link(rss_torrent.link)
      if torrent.new_record?
        torrent.title = rss_torrent.title
        torrent.published = rss_torrent.pubDate.to_datetime
        torrent.category = rss_torrent.category.content
        torrent.description = rss_torrent.description
        torrent.save
      end
    end
  end

  def self.download_all_torrent_data
    items = []
    Feed.all.each do |feed|
      body = RestClient.get(feed.url)
      rss = RSS::Parser.parse(body, false)
      rss.items.map { |item| items << item }
    end
    items
  end
end
