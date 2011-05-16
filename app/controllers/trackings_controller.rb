class TrackingsController < ApplicationController
  before_filter :get_tracking, :only => [:show, :edit, :update, :destroy]

  def index
    @trackings = Tracking.all
  end

  def show
  end

  def new
    @tracking = Tracking.new
  end

  def edit
  end

  def create
    @tracking = Tracking.new(params[:tracking])
    if @tracking.save
      redirect_to trackings_path, :notice => 'Tracking was successfully created.'
    else
      render :new
    end
  end

  def update
    if @tracking.update_attributes(params[:tracking])
      redirect_to @tracking, :notice => 'Tracking was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @tracking.destroy
    redirect_to trackings_url
  end

  private

  def get_tracking
    @tracking = Tracking.find(params[:id])
  end
end
