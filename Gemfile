# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/CodiTramuntana/decidim.git", branch: "release/0.25-stable" }.freeze

gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-decidim_awesome", "~> 0.8.0"
gem "decidim-file_authorization_handler", git: "https://github.com/CodiTramuntana/decidim-file_authorization_handler.git", tag: "v0.25.2"
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-members", git: "https://github.com/CodiTramuntana/decidim-members.git", tag: "v0.1.19"
gem "decidim-sortitions", DECIDIM_VERSION
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer"
gem "decidim-verifications-csv_email", git: "https://github.com/CodiTramuntana/decidim-verifications-csv_emails.git", tag: "v0.0.10"
gem "decidim-verifications-sant_boi_census", git: "https://github.com/CodiTramuntana/decidim-verifications-sant_boi_census.git", tag: "v0.1.0"

gem "sanitize", "~> 5.2"

gem "daemons"
gem "delayed_job_active_record"
gem "puma"
gem "uglifier", ">= 1.3.0"
gem "whenever", require: false

gem "figaro", ">= 1.1.1"
gem "openssl"

gem "decidim", DECIDIM_VERSION

# Remove this nokogiri forces version at any time but make sure that no __truncato_root__ text appears in the cards in general.
# More exactly in comments in the homepage and in processes cards in the processes listing
gem "nokogiri", "= 1.13.3"

group :development, :test do
  gem "better_errors", ">= 2.3.0"
  gem "binding_of_caller"
  gem "byebug", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker"
  gem "whenever-test"
end

group :development do
  gem "letter_opener_web"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"
end
