class ApplicationController < ActionController::Base
  before_action :authenticate_user!, only: :logged_in
  protect_from_forgery with: :exception

  TENANTS = {
    'example.com' => "08909493-cc6f-4a67-9986-f8f4452ba1d4",
    'your-email-domain.com' => "4eaff58f-40a2-4ebe-b746-a9dbe2103864"
  }

  def idp_login
    domain = params[:email].split('@').last
    idp_id = TENANTS[domain]

    render json: { identity_provider_id: idp_id }
  end

  def index
  end

  def logged_in
  end
end
