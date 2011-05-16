class AddTrackingIdToTorrents < ActiveRecord::Migration
  def change
    add_column :torrents, :tracking_id, :integer
  end
end
