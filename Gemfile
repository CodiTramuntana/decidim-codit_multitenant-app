source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION= '~> 0.18.0'

gem 'decidim', DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-sortitions", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem 'decidim-members', git: "https://github.com/CodiTramuntana/decidim-members.git", tag: "v0.1.15"
gem 'decidim-verifications-csv_email', git: "https://github.com/CodiTramuntana/decidim-verifications-csv_emails.git", tag: "v0.0.6"
gem 'decidim-file_authorization_handler', git: "https://github.com/MarsBased/decidim-file_authorization_handler.git"
gem "decidim-term_customizer", git: "https://github.com/CodiTramuntana/decidim-module-term_customizer.git"
gem 'decidim-verifications-sant_boi_census', git: "https://github.com/CodiTramuntana/decidim-verifications-sant_boi_census.git", tag: "v0.0.1"

gem 'delayed_job_active_record'
gem 'daemons'
gem 'sanitize', '~> 4.0', '>= 4.0.1'

gem "whenever", require: false

gem 'puma', '~> 3.0'
gem 'uglifier', '>= 4.0.0'
gem 'figaro', '>= 1.1.1'

group :development, :test do
  gem 'faker', '~> 1.9.1'
  gem 'byebug', platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem 'whenever-test'
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.1.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener_web', '~> 1.3.0'

  gem 'better_errors', '>= 2.3.0'
  gem 'binding_of_caller'
end
