require 'spec_helper'

describe Torrent do
  before do
    @valid_attributes = {
      :title => "Torrent title",
      :link => "http://example.com/Torrent.title.torrent",
      :published => Time.now
    }
  end

  it_should_require :title, :link, :published

  it "extracts filename from link before save" do
    torrent = Torrent.create(@valid_attributes)
    torrent.filename.should == "Torrent.title.torrent"
  end

  describe "self.match" do
    it "finds a torrent that matches a title" do
      Factory :torrent, :title => "An example title"
      tracking = Factory :tracking, :title => "An example title"
      Torrent.match(tracking).should have(1).torrent
    end
  end

  describe "scope unmatched" do
    it "finds all unmatched torrents" do
      tracking = Factory :tracking
      Factory :torrent, :tracking => tracking
      Factory :torrent
      Factory :torrent
      Torrent.all.should have(3).torrent
      Torrent.unmatched.should have(2).torrent
    end
  end

  describe ".download" do
    before do 
      @torrent = Factory :torrent, {:link => "http://example.org/example.torrent", 
                                    :title => "Torrent file title"} 
      stub_request(:get, @torrent.link).to_return(:body => "content")
      @file_path = "#{TorrentTracker::Application.settings[:torrent_download_folder]}/#{@torrent.title}.torrent"
      File.delete(@file_path) if File.exists?(@file_path)
    end

    it "downloads the torrent to the destination specified in app settings" do
      @torrent.download
      File.exists?(@file_path).should be_true
    end

    it "creates the destination folder if i doesn't exist" do
      TorrentTracker::Application.settings[:torrent_download_folder] += "/a/folder"
      @file_path = "#{TorrentTracker::Application.settings[:torrent_download_folder]}/#{@torrent.title}.torrent"
      @torrent.download
      File.exists?(@file_path).should be_true
    end

    after do
      File.delete(@file_path) if File.exists?(@file_path)
    end
  end

  describe ".copied!" do
    it "sets torrent as copied" do
      torrent = Factory :torrent, :copied => false
      torrent.copied!
      torrent.should be_copied
    end
  end

  describe "self.download_folder" do
    it "takes the download folder from application settings" do
      TorrentTracker::Application.settings[:torrent_download_folder] = "/folder/structure"
      Torrent.download_folder.should == "/folder/structure"
    end

    it "expands ~" do
      TorrentTracker::Application.settings[:torrent_download_folder] = "~/"
      Torrent.download_folder.should == Dir.home
    end
  end
end
