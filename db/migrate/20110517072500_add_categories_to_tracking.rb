class AddCategoriesToTracking < ActiveRecord::Migration
  def change
    add_column :trackings, :categories, :text
  end
end
