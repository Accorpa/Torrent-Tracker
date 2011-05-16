require 'spec_helper'

describe FetchTorrents do
  describe "self.perform" do
    it "downloads all new torrents" do
      stub_feed_url Factory(:feed).url, "torrent_feed.xml"
      Factory :tracking, :title => ".*"
      stub_torrent_url
      FetchTorrents.perform
      %w(1 2).each do |nr|
        File.exists?("#{Torrent.download_folder}/Torrent file title #{nr}.torrent").should be_true
      end
    end

    after do
      %w(1 2).each do |nr|
        File.delete("#{Torrent.download_folder}/Torrent file title #{nr}.torrent")
      end
    end
  end

  def stub_torrent_url
    stub_request(:any, /http:\/\/example.org\/rss\/download\/.*/).to_return(:body => "A torrent file's content")
  end

  def stub_feed_url(url, filename)
    stub_request(:any, url).to_return(:body => torrent_feed_fixture(filename))
  end

  def torrent_feed_fixture(filename)
    File.new(File.join(Rails.root,"spec","fixtures",filename))
  end
end
