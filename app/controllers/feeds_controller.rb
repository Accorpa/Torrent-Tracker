class FeedsController < ApplicationController
  before_filter :get_feed, :only => [:show, :edit, :update, :destroy]

  def index
    @feeds = Feed.all
  end

  def show
  end

  def new
    @feed = Feed.new
  end

  def edit
  end

  def create
    @feed = Feed.new(params[:feed])

    if @feed.save
      redirect_to feeds_path, :notice => 'Feed was successfully created.'
    else
      render :new
    end
  end

  def update
    if @feed.update_attributes(params[:feed])
      redirect_to feeds_path, :notice => 'Feed was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @feed.destroy
    redirect_to feeds_url
  end

  private

  def get_feed
    @feed = Feed.find(params[:id])
  end
end
