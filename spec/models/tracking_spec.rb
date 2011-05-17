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


  describe ".has_category?" do
    it "returns false if categories is nil" do
      tracking = Factory :tracking, :categories => nil
      tracking.has_category?("Category 1").should be_false
    end

    it "returns true if category is in categories" do
      tracking = Factory :tracking, :categories => ["Category 1", "Category 2"]
      tracking.has_category?("Category 1").should be_true
    end

    it "returns false if category is not in categories" do
      tracking = Factory :tracking, :categories => ["Category 1", "Category 2"]
      tracking.has_category?("Category 3").should be_false
    end
  end
end
