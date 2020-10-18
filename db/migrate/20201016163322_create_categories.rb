class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :active
      t.integer :price

      t.timestamps
    end
  end
end
