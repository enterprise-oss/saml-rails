class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery with: :exception, except: :saml 
    
  def saml
    auth_hash = request.env['omniauth.auth']
    @user = User.create_or_find_by!(email: auth_hash['uid'])
    
    sign_in(@user)
    
    redirect_to(:logged_in)
  end
end
