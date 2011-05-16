class AddCopiedToTorrent < ActiveRecord::Migration
  def change
    add_column :torrents, :copied, :boolean, :default => false
  end
end
