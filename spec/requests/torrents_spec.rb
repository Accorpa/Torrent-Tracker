require 'spec_helper'

describe "Torrents" do
  describe "GET /torrents" do
    it "has a link to trackings" do
      visit torrents_path
      click_link "Trackings"
      current_path.should == trackings_path
    end

    it "has a link to feeds" do
      visit torrents_path
      click_link "Feeds"
      current_path.should == feeds_path
    end
    
    it "lists all the torrents" do
      Factory :torrent, :title => "Torrent title 1"
      Factory :torrent, :title => "Torrent title 2"
      visit torrents_path
      page.should have_content "Torrent title 1"
      page.should have_content "Torrent title 2"
    end

    it "shows torrents published date" do
      time = Time.now.utc
      Factory :torrent, :published => time
      visit torrents_path
      page.should have_content time.to_s(:short)
    end

    it "shows a download link next to every torrent" do
      Factory :torrent, :title => "Torrent title 1"
      visit torrents_path
      page.should have_content "Download"
    end

    it "shows which torrents that have been copied" do
      Factory :torrent, :copied => true
      visit torrents_path
      page.should have_content "Copied"
      page.should_not have_content "Not copied"
    end

    it "shows which torrents that have not been copied" do
      Factory :torrent, :copied => false
      visit torrents_path
      page.should have_content "Not copied"
      page.should_not have_content "Copied"
    end

    it "shows which torrents that have been downloaded" do
      Factory :torrent, :downloaded => true
      visit torrents_path
      page.should have_content "Downloaded"
      page.should_not have_content "Not downloaded"
    end

    it "shows which torrents that have not been downloaded" do
      Factory :torrent, :downloaded => false
      visit torrents_path
      page.should have_content "Not downloaded"
      page.should_not have_content "Downloaded"
    end

    it "shows which feed the torrent is from" do
      feed = Factory :feed, {:name => "Feed name"}
      Factory :torrent, {:feed => feed}
      visit torrents_path
      page.should have_content "Feed name"
    end
  end

  describe "GET /torrents/x/download" do
    it "downloads the torrent" do
      torrent = Factory :torrent
      stub_request(:get, torrent.link)
      visit download_torrent_path(torrent)
      page.should have_content "Torrent was successfully downloaded"
    end
  end
end
