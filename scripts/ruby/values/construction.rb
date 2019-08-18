# frozen_string_literal: true

begin
  require "bundler/inline"
rescue LoadError
  abort "Bundler 1.10 or later is required."
end

gemfile true do
  source "https://rubygems.org"
  gem "benchmark-ips"
  gem "values"
  gem "dry-struct"
  gem "value_semantics"
end

require "benchmark/ips"
require "ostruct"

MAX = 1_000_000

StructExample = Struct.new :to, :from
ValueExample = Value.new :to, :from

module Types
  include Dry::Types.module
end

DryExample = Class.new Dry::Struct do
  attribute :to, Types::Strict::String
  attribute :from, Types::Strict::String
end

ValueSemanticsExample = Class.new do
  # rubocop:disable Lint/AmbiguousBlockAssociation
  include ValueSemantics.for_attributes {
    to String
    from String
  }
  # rubocop:enable Lint/AmbiguousBlockAssociation
end

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Struct" do
    MAX.times { StructExample[to: "Rick", from: "Morty"] }
  end

  benchmark.report "OpenStruct" do
    MAX.times { OpenStruct.new to: "Rick", from: "Morty" }
  end

  benchmark.report "Values" do
    MAX.times { ValueExample.new "Rick", "Morty" }
  end

  benchmark.report "Dry Struct" do
    MAX.times { DryExample.new to: "Rick", from: "Morty" }
  end

  benchmark.report "Value Semantics" do
    MAX.times { ValueSemanticsExample.new to: "Rick", from: "Morty" }
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
              Struct     1.000  i/100ms
          OpenStruct     1.000  i/100ms
              Values     1.000  i/100ms
          Dry Struct     1.000  i/100ms
     Value Semantics     1.000  i/100ms
Calculating -------------------------------------
              Struct      1.804  (± 0.0%) i/s -     10.000  in   5.559868s
          OpenStruct      0.771  (± 0.0%) i/s -      4.000  in   5.211279s
              Values      0.494  (± 0.0%) i/s -      3.000  in   6.090192s
          Dry Struct      0.156  (± 0.0%) i/s -      1.000  in   6.409267s
     Value Semantics      0.246  (± 0.0%) i/s -      2.000  in   8.131972s

Comparison:
              Struct:        1.8 i/s
          OpenStruct:        0.8 i/s - 2.34x  slower
              Values:        0.5 i/s - 3.65x  slower
     Value Semantics:        0.2 i/s - 7.33x  slower
          Dry Struct:        0.2 i/s - 11.56x  slower
