Devise.setup do |config|
  config.omniauth :idcat_mobil,
                  ENV["IDCAT_MOBIL_CLIENT_ID"],
                  ENV["IDCAT_MOBIL_CLIENT_SECRET"],
                  ENV["IDCAT_MOBIL_SITE_URL"],
                  scope: :public
end

Decidim::User.omniauth_providers << :idcat_mobil

