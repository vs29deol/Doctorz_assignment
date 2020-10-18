Rails.application.routes.draw do
    devise_for :users
    root to: "bookings#index"
    resources :bookings do
        collection do
          get 'theatre_revenue'
        end
    end
    resources :users
    resources :seats
    resources :shows
    resources :categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
