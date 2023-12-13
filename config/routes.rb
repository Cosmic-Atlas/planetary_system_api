Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do 
    namespace :v1 do 
      resources :planetary_systems, only: [:index, :show, :create]

      resources :planets, only: [:index, :show, :create] do 
        collection do 
          get :confirmed_planets, :to => 'planets#confirmed_planets' 
          get :unconfirmed_planets, :to => "planets#unconfirmed_planets"
          get :planet_type, :to => "planets#by_planet_type"
        end
      end

      resources :moons, only: [:index, :show]
    end
  end
end
