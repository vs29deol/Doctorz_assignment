class AddDataToCategories < ActiveRecord::Migration[6.0]
  def change
    Category.create(:name => "Platinum", :active => true, :price => 320)
    Category.create(:name => "Gold", :active => true, :price => 280)
    Category.create(:name => "Silver", :active => true, :price => 240)
  end
end
