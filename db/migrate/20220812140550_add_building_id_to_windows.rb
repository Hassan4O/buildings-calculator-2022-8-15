class AddBuildingIdToWindows < ActiveRecord::Migration[7.0]
  def change
    add_column :windows, :building_id, :int
  end
end
