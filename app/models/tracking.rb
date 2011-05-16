class Tracking < ActiveRecord::Base
  has_many :torrents

  validates :title, :destination, :presence => true

  def self.find_matching_torrents
    matches = Torrent.match Tracking.all
  end
end
