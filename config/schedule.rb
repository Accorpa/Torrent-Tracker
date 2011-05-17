every 2.minutes do
  runner "TorrentFetcher.perform"
  runner "DownloadsHandler.new.perform"
end
