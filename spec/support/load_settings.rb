TorrentTracker::Application.settings = HashWithIndifferentAccess.new({
  :torrent_download_folder => "#{Rails.root}/tmp/torrents",
  :downloaded_files_folder => "#{Rails.root}/spec/fixtures/downloads",
  :remove_files_after_handling => false,
  :unrar_command => "/usr/local/bin/unrar e -y %",
})
