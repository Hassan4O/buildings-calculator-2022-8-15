class AddUserIdToBuildings < ActiveRecord::Migration[7.0]
  def change
    add_column :buildings, :user_id, :int
  end
end
