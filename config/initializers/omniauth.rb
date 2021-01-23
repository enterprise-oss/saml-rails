SAML_SETTINGS = {
  '08909493-cc6f-4a67-9986-f8f4452ba1d4' => {
    idp_sso_target_url: "https://idp.ossoapp.com/saml-login",
    idp_cert: Rails.application.credentials.idp_cert,
  },
  '4eaff58f-40a2-4ebe-b746-a9dbe2103864' => {
    idp_sso_target_url: "https://dev-634049.okta.com/app/dev-634049_railsdemo_1/exk1yj3meeGRUVVT04x7/sso/saml",
    idp_cert: Rails.application.credentials.okta_cert,
  }
}

UUID_REGEXP = /[0-9a-f]{8}-[0-9a-f]{3,4}-[0-9a-f]{4}-[0-9a-f]{3,4}-[0-9a-f]{12}/. freeze

Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth::MultiProvider.register(
    self,
    provider_name: :saml,
    identity_provider_id_regex: UUID_REGEXP,
    path_prefix: '/users/auth/saml',
    callback_suffix: 'callback',
  ) do |identity_provider_id, rack_env|
    request = Rack::Request.new(rack_env)

    SAML_SETTINGS[identity_provider_id].merge({
      assertion_consumer_service_url: acs_url(request.url),
      sp_entity_id: sp_entity_id(identity_provider_id, request),
    })
  end

  def acs_url(request_url)
    url = request_url.chomp('/callback')
    url + '/callback'
  end

  def sp_entity_id(identity_provider_id, request)
    ['http:/', request.host_with_port, identity_provider_id].join('/')
  end
end
