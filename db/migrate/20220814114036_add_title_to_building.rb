class AddTitleToBuilding < ActiveRecord::Migration[7.0]
  def change
    add_column :buildings, :title, :string
  end
end
