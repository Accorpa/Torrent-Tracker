require 'rss/1.0'
require 'rss/2.0'

class Feed < ActiveRecord::Base
  has_many :torrents

  validates :url, :name, :presence => true

  class << self
    def save_all_new_torrent_data
      Feed.all.each do |feed|
        feed.save_new_torrent_data
      end
    end

    def download_all_torrent_data
      items = []
      Feed.all.each do |feed|
        items << feed.download_torrent_data
      end
      items.flatten
    end
  end
  
  def save_new_torrent_data
    download_torrent_data.each do |rss_torrent|
      torrent = Torrent.find_or_initialize_by_link(rss_torrent.link)
      self.torrents << torrent if torrent.new_record?
      save_rss_data_to_torrent(torrent, rss_torrent)
    end
  end

  def download_torrent_data
    body = RestClient.get(url)
    rss = RSS::Parser.parse(body, false)
    rss.items
  end

  private
  
  def save_rss_data_to_torrent(torrent, rss_torrent)
    torrent.title = rss_torrent.title
    torrent.published = rss_torrent.pubDate.to_datetime
    torrent.category = rss_torrent.category.content
    torrent.description = rss_torrent.description
    torrent.save
  end

  
end
