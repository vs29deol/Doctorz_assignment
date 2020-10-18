class CreateJoinTableSeatShow < ActiveRecord::Migration[6.0]
  def change
    create_join_table :seats, :shows do |t|
      t.index [:seat_id, :show_id]
      # t.index [:show_id, :seat_id]
    end
  end
end
