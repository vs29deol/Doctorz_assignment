class Show < ApplicationRecord
    has_and_belongs_to_many :seats
    has_many :bookings
end
