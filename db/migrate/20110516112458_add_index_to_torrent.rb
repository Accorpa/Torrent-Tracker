class AddIndexToTorrent < ActiveRecord::Migration
  def change
    add_index :torrents, :tracking_id
  end
end
