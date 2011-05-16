class CreateTorrents < ActiveRecord::Migration
  def change
    create_table :torrents do |t|
      t.string :title, :null => false
      t.string :category
      t.string :link, :null => false
      t.text :description
      t.datetime :published, :null => false
      t.timestamps
    end
  end
end
