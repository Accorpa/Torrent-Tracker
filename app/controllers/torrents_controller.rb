class TorrentsController < ApplicationController
  def index
    @torrents = Torrent.order("published DESC")
  end

  def download
    Torrent.find(params[:id]).download
    redirect_to torrents_path, :notice => 'Torrent was successfully downloaded.'
  end
end
