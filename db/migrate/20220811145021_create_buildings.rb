class CreateBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :buildings do |t|
      t.decimal :total_useful_wastage_height
      t.decimal :total_useful_wastage_width
      t.decimal :total_wastage_height
      t.decimal :total_wastage_width
      t.decimal :liner_meter
      t.decimal :sq_meter

      t.timestamps
    end
  end
end
