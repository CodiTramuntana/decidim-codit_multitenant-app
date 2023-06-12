# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim.git", branch: "release/0.27-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-sortitions", DECIDIM_VERSION

gem "decidim-file_authorization_handler", git: "https://github.com/CodiTramuntana/decidim-file_authorization_handler.git", branch: "master"
gem "decidim-members", git: "https://github.com/CodiTramuntana/decidim-members.git"
gem "decidim-survey_results", git: "https://github.com/CodiTramuntana/decidim-module-survey_results"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer"
gem "decidim-verifications-csv_email", git: "https://github.com/CodiTramuntana/decidim-verifications-csv_emails.git", tag: "v0.0.11"
gem "decidim-verifications-sant_boi_census", git: "https://github.com/CodiTramuntana/decidim-verifications-sant_boi_census.git", tag: "v0.1.4"

# temporal solution while gems embrace new psych 4 (the default in Ruby 3.1) behavior.
gem "psych", "< 4"

# Required gem from decidim-members
gem "sanitize"

gem "figaro", ">= 1.1.1"
gem "openssl"

gem "puma"
gem "uglifier", ">= 1.3.0"
gem "webpacker"

# if deploying to a dedicated server
gem "daemons"
gem "delayed_job_active_record"
gem "whenever"
# elsif deploying to a PaaS like Heroku
# gem "redis"
# gem "sidekiq"
# group :production do
#   gem "aws-sdk-s3", require: false
#   gem "fog-aws"
#   gem "rack-ssl-enforcer"
#   gem "rails_12factor"
# end
# endif

group :development, :test do
  # Fixed to 2.9.1 version in order to avoid sassc error
  gem "better_errors", "~> 2.9.1"
  gem "binding_of_caller"
  gem "bootsnap"
  gem "byebug", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end
