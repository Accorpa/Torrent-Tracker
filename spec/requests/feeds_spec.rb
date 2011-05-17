require 'spec_helper'

describe "Feeds" do
  describe "GET /feeds" do
    before do
      Factory :feed
    end

    it "lists feeds" do
      visit feeds_path
      page.should have_content "Feed name"
    end

    it "has a link to trackings" do
      visit feeds_path
      click_link "Trackings"
      current_path.should == trackings_path
    end

    it "has a link to torrents" do
      visit feeds_path
      click_link "Torrents"
      current_path.should == torrents_path
    end
  end

  describe "POST /feeds" do
    before do
      visit new_feed_path
      fill_in "Name", :with => "Feed name"
      fill_in "URL", :with => "http://example.com"
      click_button "Add"
    end

    it "creates a feed" do
      page.should have_content "Feed was successfully created."
      page.should have_content "Feed name"
    end

    it "redirects to feed index" do
      current_path.should == feeds_path
    end
  end
end
