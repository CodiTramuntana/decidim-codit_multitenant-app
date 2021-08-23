# frozen_string_literal: true

unless ENV["CI"]
  env = Rails.env
  keys = %w(SECRET_KEY_BASE)
  keys += %w(DB_DATABASE DB_PASSWORD DB_USERNAME)
  unless env.development? || env.test?
    keys += %w(SENDGRID_USERNAME SENDGRID_PASSWORD)
    keys += %w(GEOCODER_LOOKUP_API_KEY)
    keys += %w(SANT_BOI_CENSUS_URL SANT_BOI_CENSUS_SECRET SANT_BOI_CENSUS_USER SANT_BOI_CENSUS_PASSWORD SANT_BOI_CENSUS_DBOID)
  end
  Figaro.require_keys(keys)
end
