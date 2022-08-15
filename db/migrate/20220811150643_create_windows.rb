class CreateWindows < ActiveRecord::Migration[7.0]
  def change
    create_table :windows do |t|
      t.integer :window_width
      t.integer :window_height
      t.integer :window_watage_width
      t.integer :window_wastage_height
      t.integer :window_instllation_pice
      t.integer :window_roll_width
      t.integer :window_roll_height
      t.string :window_message
      t.integer :window_useful_height
      t.integer :window_useful_width
      t.integer :window_wastage_pice

      t.timestamps
    end
  end
end
