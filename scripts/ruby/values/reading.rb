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
dry_struct = DryExample[to: "Rick", from: "Morty"]
value_struct = ValueExample.new "Rick", "Morty"
value_semantics_struct = ValueSemanticsExample.new to: "Rick", from: "Morty"

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Struct" do
    struct.to
  end

  benchmark.report "OpenStruct" do
    open_struct.to
  end

  benchmark.report "Dry Struct" do
    dry_struct.to
  end

  benchmark.report "Values" do
    value_struct.to
  end

  benchmark.report "Value Semantics" do
    value_semantics_struct.to
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
              Struct   364.572k i/100ms
          OpenStruct   294.449k i/100ms
          Dry Struct   308.103k i/100ms
              Values   316.972k i/100ms
     Value Semantics   308.440k i/100ms
Calculating -------------------------------------
              Struct     16.113M (± 8.4%) i/s -     80.206M in   5.020886s
          OpenStruct      7.980M (± 9.0%) i/s -     39.751M in   5.027391s
          Dry Struct     12.634M (± 6.4%) i/s -     63.161M in   5.021099s
              Values     17.151M (± 7.0%) i/s -     85.582M in   5.015734s
     Value Semantics     15.038M (± 6.9%) i/s -     74.951M in   5.009867s

Comparison:
              Values: 17150852.8 i/s
              Struct: 16112953.3 i/s - same-ish: difference falls within error
     Value Semantics: 15037930.9 i/s - same-ish: difference falls within error
          Dry Struct: 12634384.8 i/s - 1.36x  slower
          OpenStruct:  7979713.3 i/s - 2.15x  slower
