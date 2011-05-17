class TorrentFetcher
  def self.perform
    Feed.save_all_new_torrent_data
    Tracking.find_matching_torrents.each do |torrent|
      torrent.download
    end
  end
end
