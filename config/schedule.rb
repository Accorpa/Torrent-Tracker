every 2.minutes do
  runner "FetchTorrents.perform"
  runner "HandleDownloads.new(\"#{ENV["TR_TORRENT_DIR"]}\",\"#{ENV["TR_TORRENT_NAME"]}\").delay.perform"
end
