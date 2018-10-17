env= Rails.env
keys = %w{ SECRET_KEY_BASE }
unless env.development? or env.test?
  keys += %w{ DB_DATABASE DB_PASSWORD DB_USERNAME }
  keys += %w{ SENDGRID_USERNAME SENDGRID_PASSWORD }
  keys += %w{ GEOCODER_LOOKUP_APP_ID GEOCODER_LOOKUP_APP_CODE }
end
Figaro.require_keys(keys)
