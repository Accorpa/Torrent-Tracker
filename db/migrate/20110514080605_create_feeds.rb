class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :url, :null => false
      t.timestamps
    end
  end
end
