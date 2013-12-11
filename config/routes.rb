Pricer::Application.routes.draw do

  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/signin' => 'sessions#new', :as => :signin

  
  resources :scraped_configurations do
    resources :configuration_lines
  end

  resources :links

  resources :items

  resources :companies

  resources :companies do
    resources :prices do
      resources :price_histories
    end
    resources :scraped_configurations do
      resources :configuration_lines
    end
  end

  resources :searches

  resources :prices

  root :to => "main#index"

end

