env= Rails.env
keys = %w{ SECRET_KEY_BASE }
unless env.development? or env.test?
  keys += %w{ DB_DATABASE DB_PASSWORD DB_USERNAME }
  keys += %w{ SENDGRID_USERNAME SENDGRID_PASSWORD }
  keys += %w{ GEOCODER_LOOKUP_APP_ID GEOCODER_LOOKUP_APP_CODE }
  keys += %w{ IDCAT_MOBIL_CLIENT_ID IDCAT_MOBIL_CLIENT_SECRET IDCAT_MOBIL_SITE_URL }
end
Figaro.require_keys(keys)
