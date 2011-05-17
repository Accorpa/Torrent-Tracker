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

  describe "self.categories" do
    it "gets all the different categories" do
      Factory :torrent, :category => "Category 1"
      Factory :torrent, :category => "Category 2"
      Torrent.categories.should == ["Category 1", "Category 2"]
    end
  end
  describe "self.match" do
    it "finds a torrent that matches a title" do
      Factory :torrent, :title => "An example title"
      tracking = Factory :tracking, :title => "An example title"
      Torrent.match(tracking).should have(1).torrent
    end

    it "finds the torrent in correct category" do
      Factory :torrent, :title => "An example title 1", :category => "Category 1"
      Factory :torrent, :title => "An example title 2", :category => "Category 1"
      Factory :torrent, :title => "An example title 3", :category => "Category 2"
      Factory :torrent, :title => "An example title 4", :category => "Category 3"
      tracking = Factory :tracking, :title => "An example title [1-4]", :categories => ["Category 1", "Category 3"]
      Torrent.match(tracking).should have(3).torrents
    end
  end

  describe "self.unmatched" do
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

    it "sets the torrent as downloaded" do
      @torrent.download
      @torrent.should be_downloaded
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

  describe ".is_category?" do
    it "returns true if torrent is provided category" do
      torrent = Factory :torrent, :category => "Category 1"
      torrent.is_category?("Category 1").should be_true
    end

    it "returns false if torrent is not provided category" do
      torrent = Factory :torrent, :category => "Category 1"
      torrent.is_category?("Category 2").should be_false
    end
  end
  describe ".downloaded!" do
    it "sets torrent as downloaded" do
      torrent = Factory :torrent, :downloaded => false
      torrent.downloaded!
      torrent.should be_downloaded
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
