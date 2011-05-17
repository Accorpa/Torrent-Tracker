class Tracking < ActiveRecord::Base
  has_many :torrents

  validates :title, :destination, :presence => true

  serialize :categories

  def self.find_matching_torrents
    matches = Torrent.match Tracking.all
  end

  def has_category?(category)
    categories.present? && categories.include?(category)
  end
end
