class Category < ApplicationRecord
    has_many :seats, dependent: :destroy
end
