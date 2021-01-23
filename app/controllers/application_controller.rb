class ApplicationController < ActionController::Base
  before_action :authenticate_user!, only: :logged_in
  skip_before_action :verify_authenticity_token, only: :saml_callback
  
  def index
  end

  def logged_in
  end

  def saml_login
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def saml_callback
    response = OneLogin::RubySaml::Response.new(
      params[:SAMLResponse],
      :settings => saml_settings
    )
  
    if response.is_valid?
      @user = User.create_or_find_by!(email: response.nameid)
      sign_in(@user)
      redirect_to(:logged_in)
    else
      raise response.errors.inspect
    end
  end

  private

  def saml_settings
    settings = OneLogin::RubySaml::Settings.new
    
    # You provide to IDP
    settings.assertion_consumer_service_url = "http://#{request.host_with_port}/saml_callback"
    settings.sp_entity_id                   = "my-single-tenant"
    
    # IDP provides to you
    settings.idp_sso_target_url             = "https://idp.ossoapp.com/saml-login"
    settings.idp_cert                       = Rails.application.credentials.idp_cert
    
    settings
  end
end
