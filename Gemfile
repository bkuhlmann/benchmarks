# frozen_string_literal: true

ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "benchmark-ips", "~> 2.10"
gem "dry-struct", "~> 1.5"
gem "refinements", "~> 9.7"
gem "values", "~> 1.8"
gem "value_semantics", "~> 3.2"

group :code_quality do
  gem "caliber", "~> 0.16"
  # gem "git-lint", "~> 4.0"
  gem "reek", "~> 6.1"
  gem "simplecov", "~> 0.21", require: false
end

group :development do
  gem "rake", "~> 13.0"
end

group :test do
  gem "guard-rspec", "~> 4.7", require: false
  gem "rspec", "~> 3.11"
end

group :tools do
  gem "amazing_print", "~> 1.4"
  gem "debug", "~> 1.6"
end
