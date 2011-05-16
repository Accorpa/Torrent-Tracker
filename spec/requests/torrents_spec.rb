require 'spec_helper'

describe "Torrents" do
  describe "GET /torrents" do
    it "lists all the torrents" do
      Factory :torrent, :title => "Torrent title 1"
      Factory :torrent, :title => "Torrent title 2"
      visit torrents_path
      page.should have_content "Torrent title 1"
      page.should have_content "Torrent title 2"
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
      page.should have_content "Yes"
      page.should_not have_content "No"
    end

    it "shows which torrents that have not been copied" do
      Factory :torrent, :copied => false
      visit torrents_path
      page.should have_content "Copied"
      page.should have_content "No"
      page.should_not have_content "Yes"
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
