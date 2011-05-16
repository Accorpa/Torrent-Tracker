require 'net/http'

class Torrent < ActiveRecord::Base
  belongs_to :tracking

  delegate :destination, :to => :tracking

  validates :title, :link, :published, :presence => true

  before_validation :extract_filename_from_link

  scope :unmatched, where(:tracking_id => nil)

  def self.match(*trackings)
    matches = []
    torrents = Torrent.unmatched
    trackings.flatten.each do |tracking|
      torrents.each do |torrent|
        if torrent.title.match(tracking.title)
          matches << torrent
          tracking.torrents << torrent
        end
      end
    end
    matches
  end

  def download
    create_download_folder
    uri = URI.parse(link)
    Net::HTTP.start(uri.host, uri.port) do |http|
      response = http.get(uri.path)
      open("#{Torrent.download_folder}/#{title}.torrent", "wb") do |file|
        file.write response.body
      end
    end
  end

  def copied!
    update_attribute :copied, true
  end

  def self.download_folder
    File.expand_path(TorrentTracker::Application.settings[:torrent_download_folder])
  end

  private

  def create_download_folder
    FileUtils.mkdir_p Torrent.download_folder
  end

  def extract_filename_from_link
    self.filename = File.basename(link) unless link.nil?
  end

end
