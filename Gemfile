source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION= '~> 0.16.0'

# gem 'rails', '<= 5.2.0'
gem 'decidim', DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-sortitions", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem 'decidim-members', git: "https://github.com/CodiTramuntana/decidim-members.git", tag: "v0.1.11"
gem 'decidim-verifications-csv_email', git: "https://github.com/CodiTramuntana/decidim-verifications-csv_emails.git", tag: "v0.0.5"
gem 'decidim-file_authorization_handler', git: "https://github.com/CodiTramuntana/decidim-file_authorization_handler.git", tag: "v0.15.0"

gem 'delayed_job_active_record'
gem 'daemons'

gem "whenever", require: false

gem 'puma', '~> 3.0'
gem 'uglifier', '>= 4.0.0'
gem 'figaro', '>= 1.1.1'

## Start force versions Gem
gem 'graphiql-rails', '1.4.11'
gem 'graphql', '1.8.10'
## End force versions Gem

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
