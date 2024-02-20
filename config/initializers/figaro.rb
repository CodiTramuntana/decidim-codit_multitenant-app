# frozen_string_literal: true

unless ENV["CI"]
  env = Rails.env
  keys = %w(SECRET_KEY_BASE)
  unless env.development? || env.test?
    keys += %w(DB_DATABASE DB_PASSWORD DB_USERNAME)
    keys += %w(MAILER_SMTP_ADDRESS MAILER_SMTP_DOMAIN MAILER_SMTP_PORT MAILER_SMTP_USER_NAME MAILER_SMTP_PASSWORD)
    keys += %w(GEOCODER_LOOKUP_API_KEY)
    keys += %w(SANT_BOI_CENSUS_URL SANT_BOI_CENSUS_SECRET SANT_BOI_CENSUS_USER SANT_BOI_CENSUS_PASSWORD SANT_BOI_CENSUS_DBOID)
  end
  Figaro.require_keys(keys)
end
