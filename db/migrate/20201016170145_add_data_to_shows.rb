class AddDataToShows < ActiveRecord::Migration[6.0]
  def change
    Show.create(:name => "Show_1", :active => true)
    Show.create(:name => "Show_2", :active => true)
    Show.create(:name => "Show_3", :active => true)
  end
end
