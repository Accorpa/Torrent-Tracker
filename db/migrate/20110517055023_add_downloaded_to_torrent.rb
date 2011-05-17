class AddDownloadedToTorrent < ActiveRecord::Migration
  def change
    add_column :torrents, :downloaded, :boolean, :default => false
  end
end
