class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :entries do |t|
      t.string :user_id
      t.string :room_id
      t.timestamps
    end
  end
end
