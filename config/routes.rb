Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do 
    namespace :v1 do 
      resources :planetary_systems, only: [:index, :show, :create] do 
        collection do 
          # get "search_planetary_systems/:name", :to => 'planetary_systems#search_planetary_systems'
          get "search_planetary_systems/", :to => 'planetary_systems#search_planetary_systems'
          get "system_planet_count", :to => 'planetary_systems#system_planet_count'
        end
      end

      resources :planets, only: [:index, :show, :create] do 
        collection do 
          get :confirmed_planets, :to => 'planets#confirmed_planets' 
          get :unconfirmed_planets, :to => "planets#unconfirmed_planets"
          get :planet_type, :to => "planets#by_planet_type"

          get "search_planets/", :to => 'planets#search_planets'
        end
      end

      resources :moons, only: [:index, :show, :create] do 
        collection do 
          get :moons_by_planet, :to => 'moons#by_planet'
        end
      end
    end
  end
end
