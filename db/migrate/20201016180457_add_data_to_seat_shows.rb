class AddDataToSeatShows < ActiveRecord::Migration[6.0]
  def self.up
    Show.find_by(name: "Show_1").seat_ids = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,19,20,21,22,23,24]
    Show.find_by(name: "Show_2").seat_ids = [1,2,3,4,5,6,7,11,12,13,14,15,18,19,20,21,22,23,24]
    Show.find_by(name: "Show_3").seat_ids = [1,2,3,4,5,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]
  end
end
