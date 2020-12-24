# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = "Multitenant Decideix"

  config.mailer_sender = "decidim@coditramuntana.com"

  # Change these lines to set your preferred locales
  config.default_locale = :en
  config.available_locales = [:en, :ca, :es, :eu, :fi, :fr, :gl, :it, :nl, :pt, :ru, :sv, :uk]

  config.enable_html_header_snippets = true
  config.track_newsletter_links = true

  # Geocoder configuration
  config.maps = {
    provider: :here,
    api_key: Rails.application.secrets.maps[:api_key],
    static: { url: "https://image.maps.ls.hereapi.com/mia/1.6/mapview" }
  }
  config.geocoder = {
    timeout: 5,
    units: :km
  }

end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale
