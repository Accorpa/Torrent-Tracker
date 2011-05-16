require 'spec_helper'

describe Tracking do
  before do
    @valid_attributes = {
      :title => "Title",
      :destination => "/a/folder"
    }
  end

  it_should_require :title, :destination

  describe "#find_matching_torrents" do
    before do
      10.times do |nr|
        Factory :torrent, :title => "A title #{nr}"
      end
    end

    it "finds all torrents that matches any tracking" do
      Factory :tracking, :title => "A title 1"
      Tracking.find_matching_torrents.should have(1).torrent
    end

    it "finds torrents by regexp matching" do
      Factory :tracking, :title => "A title [0-9]"
      Tracking.find_matching_torrents.should have(10).torrents
    end

    it "only matches each torrent once" do
      Factory :tracking, :title => "A title 1"
      Tracking.find_matching_torrents.should have(1).torrent
      Tracking.find_matching_torrents.should have(0).torrents
    end

    it "connects matches to torrent" do
      tracking = Factory :tracking, :title => "A title 1"
      Tracking.find_matching_torrents
      tracking.reload.torrents.should have(1).torrent
    end
  end
end
