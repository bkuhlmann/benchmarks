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

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Struct" do
    StructExample[to: "Rick", from: "Morty"]
  end

  benchmark.report "OpenStruct" do
    OpenStruct.new to: "Rick", from: "Morty"
  end

  benchmark.report "Dry Struct" do
    DryExample[to: "Rick", from: "Morty"]
  end

  benchmark.report "Values" do
    ValueExample.new "Rick", "Morty"
  end

  benchmark.report "Value Semantics" do
    ValueSemanticsExample.new to: "Rick", from: "Morty"
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
              Struct   124.577k i/100ms
          OpenStruct    70.932k i/100ms
          Dry Struct    28.404k i/100ms
              Values    47.441k i/100ms
     Value Semantics    28.793k i/100ms
Calculating -------------------------------------
              Struct      2.010M (±16.2%) i/s -      9.842M in   5.000784s
          OpenStruct    873.558k (±10.1%) i/s -      4.327M in   5.003154s
          Dry Struct    296.609k (±10.1%) i/s -      1.477M in   5.038729s
              Values    554.974k (± 7.1%) i/s -      2.799M in   5.073966s
     Value Semantics    332.732k (± 5.0%) i/s -      1.670M in   5.031237s

Comparison:
              Struct:  2010059.9 i/s
          OpenStruct:   873557.9 i/s - 2.30x  slower
              Values:   554973.8 i/s - 3.62x  slower
     Value Semantics:   332732.3 i/s - 6.04x  slower
          Dry Struct:   296609.2 i/s - 6.78x  slower
