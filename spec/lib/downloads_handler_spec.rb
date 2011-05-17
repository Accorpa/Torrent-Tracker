require 'spec_helper'

describe DownloadsHandler do

  describe "perform" do
    before do
      FileUtils.cp_r "#{Rails.root}/spec/fixtures/example_packed/", 
                     "#{Rails.root}/spec/fixtures/downloads/"
      FileUtils.cp_r "#{Rails.root}/spec/fixtures/example_unpacked/", 
                     "#{Rails.root}/spec/fixtures/downloads/"

      @tracking_packed   = Factory :tracking, 
                                   :destination => "#{Rails.root}/tmp/torrents/example_packed"
      @tracking_unpacked = Factory :tracking, 
                                   :destination => "#{Rails.root}/tmp/torrents/example_unpacked"

      Factory :torrent, 
              :link => "example_packed.torrent", 
              :tracking => @tracking_packed
      Factory :torrent, 
              :link => "example_unpacked.torrent", 
              :tracking => @tracking_unpacked
    end

    it "only extracts and copies each torrent once" do
      FileUtils.should_receive(:cp).twice # once for packed and once for unpacked
      handler = DownloadsHandler.new
      handler.perform
      handler.perform
    end

    it "unpacks packed files" do
      DownloadsHandler.new.perform
      File.exists?("#{Rails.root}/spec/fixtures/downloads/example_packed/a movie.avi").should be_true
    end

    it "upacks files only once" do
      handler = DownloadsHandler.new
      handler.perform
      handler.should_not_receive(:extract_file)
      handler.perform
    end

    it "copies the file to the target directory" do
      DownloadsHandler.new.perform
      File.exists?(@tracking_packed.destination + "/a movie.avi").should be_true
    end

    context "without specific torrent location provided" do
      it "handles all torrents in download directory" do
        DownloadsHandler.new.perform
        File.exists?(@tracking_packed.destination + "/a movie.avi").should be_true
        File.exists?(@tracking_unpacked.destination + "/another movie.avi").should be_true
      end

    end

    context "with specific torrent location provided" do
      it "handles only that torrent" do
        DownloadsHandler.new("#{Rails.root}/spec/fixtures/downloads","example_packed.torrent").perform
        File.exists?(@tracking_packed.destination + "/a movie.avi").should be_true
        File.exists?(@tracking_unpacked.destination + "/another movie.avi").should be_false
      end
    end

    after do
      FileUtils.rm_rf "#{Rails.root}/spec/fixtures/downloads/example_packed/"
      FileUtils.rm_rf "#{Rails.root}/spec/fixtures/downloads/example_unpacked/"
      FileUtils.rm_rf "#{Rails.root}/tmp/torrents/example_packed/"
      FileUtils.rm_rf "#{Rails.root}/tmp/torrents/example_unpacked/"
    end
  end
end
