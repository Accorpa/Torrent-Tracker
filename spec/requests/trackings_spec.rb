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

    it "has a link to torrents" do
      visit trackings_path
      click_link "Torrents"
      current_path.should == torrents_path
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

    it "saves multiple categories to a tracking" do
      Factory :torrent, :category => "Category 1"
      Factory :torrent, :category => "Category 2"
      Factory :torrent, :category => "Category 3"

      visit new_tracking_path
      fill_in "Torrent title", :with => "Tracking title"
      fill_in "Destination", :with => "/a/folder"
      check "Category 1"
      check "Category 3"
      click_button "Add"
      page.should have_content "Tracking was successfully created."
      page.should have_content "Category 1"
      page.should_not have_content "Category 2"
      page.should have_content "Category 3"
    end
  end

  describe "GET /torrents/x/edit" do
    it "pre checks selected categories" do
      Factory :torrent, :category => "Category 1"
      Factory :torrent, :category => "Category 2"
      Factory :torrent, :category => "Category 3"
      tracking = Factory :tracking, :categories => ["Category 1","Category 3"]
      visit edit_tracking_path tracking
      find_field("Category 1").should be_checked
      find_field("Category 2").should_not be_checked
      find_field("Category 3").should be_checked
    end
  end

end
