require 'spec_helper'

describe "Trackings" do
  describe "GET /trackings" do
    before do
      Factory :tracking
    end
    it "lists trackings" do
      visit trackings_path
      page.should have_content "Title"
    end

    it "has a link to feeds" do
      visit trackings_path
      click_link "Feeds"
      current_path.should == feeds_path
    end
  end

  describe "POST /trackings" do
    before do
      visit new_tracking_path
      fill_in "Torrent title", :with => "Tracking title"
      fill_in "Destination", :with => "/a/folder"
      click_button "Add"
    end

    it "creates a tracking" do
      page.should have_content "Tracking was successfully created."
      page.should have_content "Tracking title"
    end

    it "redirects to trackings index" do
      current_path.should == trackings_path
    end
  end
end
