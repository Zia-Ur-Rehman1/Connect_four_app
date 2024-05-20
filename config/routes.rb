# config/routes.rb
Rails.application.routes.draw do
  resources :games do
    member do
      get :play
      post :set_piece
    end
  end
end
