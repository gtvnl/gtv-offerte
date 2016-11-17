Rails.application.routes.draw do
  resources :offertes do
    resources :posities
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'offertes#index'
end
