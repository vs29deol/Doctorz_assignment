class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.references :show, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :seat_ids, array: true, default: []
      t.decimal :sub_total
      t.decimal :service_tax
      t.decimal :swachh_bharat_cess
      t.decimal :krishi_kalyan_cess
      t.decimal :total

      t.timestamps
    end
  end
end
