class OmniauthCallbacksController < Devise::OmniauthCallbacksController    
  def osso
    auth_hash = request.env['omniauth.auth']

    @user = User.create_or_find_by!(email: auth_hash.dig(:info, :email))
    
    sign_in(@user)
    
    redirect_to(:logged_in)
  end
end
