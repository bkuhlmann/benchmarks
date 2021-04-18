# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"
require "ostruct"
require "dry-struct"
require "values"
require "value_semantics"

StructExample = Struct.new :to, :from
ValueExample = Value.new :to, :from

module Types
  include Dry.Types
end

DryExample = Class.new Dry::Struct do
  attribute :to, Types::Strict::String
  attribute :from, Types::Strict::String
end

ValueSemanticsExample = Class.new do
  include(
    ValueSemantics.for_attributes do
      to String
      from String
    end
  )
end

struct = StructExample[to: "Rick", from: "Morty"]
open_struct = OpenStruct.new to: "Rick", from: "Morty"

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Struct" do
    struct.from = "Summer"
  end

  benchmark.report "OpenStruct" do
    open_struct.from = "Summer"
  end

  # Not Supported
  # - Dry Struct
  # - Values
  # - Value Semantics

  benchmark.compare!
end

__END__

Warming up --------------------------------------
              Struct     1.648M i/100ms
          OpenStruct   996.676k i/100ms
Calculating -------------------------------------
              Struct     16.249M (± 0.9%) i/s -     82.412M in   5.072310s
          OpenStruct     10.234M (± 0.6%) i/s -     51.827M in   5.064561s

Comparison:
              Struct: 16248681.6 i/s
          OpenStruct: 10233668.4 i/s - 1.59x  (± 0.00) slower
