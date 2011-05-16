class HandleDownloads < Struct.new(:torrent_location, :torrent_filename)
  TARGET_FILES = "*.{avi,mkv,mov,mpg,mp4,srt}"

  def perform(test = "")
    @test = test
    if torrent_location.present?
      handle_files_in torrent_folder
    else
      handle_files_in_download_folder
    end
  end

  private

  def handle_files_in_download_folder
    Dir.chdir downloaded_files_folder do
      Dir["**"].each do |folder|
        handle_files_in add_pwd_to(folder)
      end
    end
  end

  def handle_files_in(folder)
    Dir.chdir folder do
      extract_rar_files
      copy_files
    end
  end

  def downloaded_files_folder
    File.expand_path TorrentTracker::Application.settings[:downloaded_files_folder]
  end

  def add_pwd_to(file_or_folder)
    "#{Dir.pwd}/#{file_or_folder}"
  end

  def extract_rar_files
    if Dir[TARGET_FILES].empty?
      Dir["*.rar"].each do |rar_file|
        extract_file(add_pwd_to(rar_file))
      end
    end
  end

  def extract_file(file)
    `#{TorrentTracker::Application.settings[:unrar_command].gsub("%", "'#{file}' '#{File.dirname(file)}/'")}`
  end

  def copy_files
    torrent = Torrent.includes(:tracking).where(:filename => directory_to_torrent_filename).first
    if torrent && torrent.copied == false && torrent.destination
      destination = File.expand_path torrent.destination  
      copy_files_to destination
      torrent.copied!
    end
  end
  
  def copy_files_to(destination)
    Dir[TARGET_FILES].each do |file|
      FileUtils.makedirs destination
      FileUtils.cp add_pwd_to(file), destination
    end
  end

  def get_current_dir
    Dir.pwd.split("/").last
  end

  def torrent_folder
    File.join(torrent_location, torrent_filename.gsub(".torrent",""))
  end

  def directory_to_torrent_filename
    get_current_dir + ".torrent"
  end
end
