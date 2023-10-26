Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do 
    namespace :v1 do 
      resources :planetary_systems, only: [:index, :show, :create]

      # resources :planets, only: [:index, :show, :create] do 
      #   # get '/filter/confirmed_planets', :to => 'planets#confirmed_planets'
      # end
      resources :planets, only: [:index, :show, :create] do 
        collection do 
          get :confirmed_planets, :to => 'planets#confirmed_planets' 
          # get '/filter/unconfirmed_planets', :to => 'planets#unconfirmed_planets' 
          get :unconfirmed_planets, :to => "planets#unconfirmed_planets"
        end
      end
    end
  end
end
