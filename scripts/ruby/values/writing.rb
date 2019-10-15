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
              Struct   352.737k i/100ms
          OpenStruct   233.353k i/100ms
Calculating -------------------------------------
              Struct     13.186M (±10.8%) i/s -     65.256M in   5.016097s
          OpenStruct      5.071M (±14.6%) i/s -     24.735M in   5.002361s

Comparison:
              Struct: 13186291.6 i/s
          OpenStruct:  5070848.1 i/s - 2.60x  slower
