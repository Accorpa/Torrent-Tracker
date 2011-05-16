class AddFilenameToTorrent < ActiveRecord::Migration
  def change
    add_column :torrents, :filename, :string
    add_index :torrents, :filename
  end
end
