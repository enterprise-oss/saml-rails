Rails.application.routes.draw do
  devise_for :users

  root to: "application#index"
  get 'logged_in', to: "application#logged_in"
  
  devise_scope :user do
    post '/users/auth/saml_idp',
      to: 'omniauth_callbacks#idp_login',
      as: 'user_idp_discovery'

    match '/users/auth/saml/:identity_provider_id/callback',
      via: [:get, :post],
      to: 'omniauth_callbacks#saml',
      as: 'user_omniauth_callback'

    post '/users/auth/saml/:identity_provider_id',
      to: 'omniauth_callbacks#passthru',
      as: 'user_omniauth_authorize'
  end
end
