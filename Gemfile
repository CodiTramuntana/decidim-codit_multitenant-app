source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION= '>= 0.15.0'

gem 'decidim', DECIDIM_VERSION
gem 'decidim-members', git: "ssh://git@gitlab.coditdev.net:534/decidim/decidim-members.git", branch: "upgrade/decidim-0.15"
gem 'decidim-verifications-csv_email', git: "https://github.com/CodiTramuntana/decidim-verifications-csv_emails.git", branch: "upgrade/decidim-0.15"
gem 'decidim-file_authorization_handler', git: "https://github.com/CodiTramuntana/decidim-file_authorization_handler.git", branch: "fix/ensure_all_data_properly_encoded"

gem 'delayed_job_active_record'
gem 'daemons'


gem 'puma', '>= 3.0'
gem 'figaro', '>= 1.1.1'

group :development, :test, :integration do
  gem 'faker', '>= 1.9.1'
  gem 'byebug', platform: :mri
end

group :development, :test, :integration do
  gem "decidim-dev", DECIDIM_VERSION
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
