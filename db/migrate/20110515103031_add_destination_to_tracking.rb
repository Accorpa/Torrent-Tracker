class AddDestinationToTracking < ActiveRecord::Migration
  def change
    add_column :trackings, :destination, :string
  end
end
