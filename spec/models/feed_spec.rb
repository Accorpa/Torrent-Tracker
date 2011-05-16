require 'spec_helper'

describe Feed do

  before do
    @valid_attributes = {
      :url => "http://example.com/feed.rss"
    }
    @feed = Factory :feed
    stub_feed_url @feed.url, "torrent_feed.xml"
  end

  it_should_require :url, :name

  describe "#download_all_torrent_data" do
    it "returns all torrents from all feeds" do
      feeds_content = Feed.download_all_torrent_data
      feeds_content.should have(2).torrents
    end
  end

  describe "#save_all_new_torrent_data" do
    it "saves all new torrents from all feeds" do
      expect {
        Feed.save_all_new_torrent_data
      }.to change(Torrent,:count).by 2
    end

    it "only saves the same torrent once" do
      expect {
        Feed.save_all_new_torrent_data
        Feed.save_all_new_torrent_data
      }.to change(Torrent,:count).by 2
    end

    it "correctly saves the category" do
      Feed.save_all_new_torrent_data
      Torrent.first.category.should == "Category"
    end
  end

  def stub_feed_url(url, filename)
    stub_request(:any, url).to_return(:body => torrent_feed_fixture(filename))
  end

  def torrent_feed_fixture(filename)
    File.new(File.join(Rails.root,"spec","fixtures",filename))
  end
end
