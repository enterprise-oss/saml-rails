Rails.application.routes.draw do
  devise_for :users, 
    :controllers => { :omniauth_callbacks => "omniauth_callbacks" },
    :skip => [:registrations]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "application#index"
  get 'logged_in', to: "application#logged_in"
end
