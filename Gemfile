source "https://rubygems.org"

ruby "3.0.0"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :test do
  gem "rspec", "~> 3.12"
end

group :development, :test do
  gem "rubocop"
end

gem "dotenv"
gem "twilio-ruby", "~> 5.74.1"
