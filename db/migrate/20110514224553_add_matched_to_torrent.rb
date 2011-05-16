class AddMatchedToTorrent < ActiveRecord::Migration
  def change
    add_column :torrents, :matched, :boolean, :default => false
  end
end
