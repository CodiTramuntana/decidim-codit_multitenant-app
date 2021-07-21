# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

DECIDIM_VERSION = { git: 'https://github.com/CodiTramuntana/decidim.git', branch: 'release/0.23-stable' }

gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-sortitions", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-members", git: "https://github.com/CodiTramuntana/decidim-members.git", tag: "v0.1.16"
gem "decidim-verifications-csv_email", git: "https://github.com/CodiTramuntana/decidim-verifications-csv_emails.git", tag: "v0.0.7"
gem "decidim-file_authorization_handler", git: "https://github.com/MarsBased/decidim-file_authorization_handler.git"
gem "decidim-term_customizer", git: "https://github.com/CodiTramuntana/decidim-module-term_customizer"
gem "decidim-verifications-sant_boi_census", git: "https://github.com/CodiTramuntana/decidim-verifications-sant_boi_census.git", tag: "v0.0.2"
gem 'sanitize', '~> 5.2'


gem 'daemons'
gem 'delayed_job_active_record'
gem 'puma', "~> 4.3"
gem 'uglifier', '>= 1.3.0'
gem "whenever", require: false

gem 'figaro', '>= 1.1.1'
gem 'openssl'

gem 'decidim', DECIDIM_VERSION

group :development, :test do
  gem 'faker', '~> 1.9.1'
  gem 'byebug', platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem 'whenever-test'
end

group :development do
  gem 'decidim-dev', DECIDIM_VERSION
  gem 'web-console'
  gem 'listen', '~> 3.1.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener_web', '~> 1.3.0'
  gem 'better_errors', '>= 2.3.0'
  gem 'binding_of_caller'
end
