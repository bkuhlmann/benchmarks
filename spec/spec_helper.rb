# frozen_string_literal: true

require "bundler/setup"
Bundler.require :tools

require "simplecov"

SimpleCov.start do
  enable_coverage :branch
  add_filter %r(^/spec/)
  minimum_coverage_by_file line: 95, branch: 95
end

using Refinements::Pathnames

Pathname.require_tree __dir__, "support/shared_contexts/**/*.rb"

RSpec.configure do |config|
  config.color = true
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "./tmp/rspec-status.txt"
  config.filter_run_when_matching :focus
  config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }
  config.order = "random"
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end
