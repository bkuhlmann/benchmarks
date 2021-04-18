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
              Struct   466.888k i/100ms
          OpenStruct    19.785k i/100ms
          Dry Struct    70.619k i/100ms
              Values   119.566k i/100ms
     Value Semantics   123.352k i/100ms
Calculating -------------------------------------
              Struct      4.626M (± 3.0%) i/s -     23.344M in   5.049972s
          OpenStruct    190.744k (± 9.0%) i/s -    949.680k in   5.007275s
          Dry Struct    703.076k (± 2.9%) i/s -      3.531M in   5.026310s
              Values      1.194M (± 0.9%) i/s -      5.978M in   5.006194s
     Value Semantics      1.242M (± 0.6%) i/s -      6.291M in   5.065980s

Comparison:
              Struct:  4626458.7 i/s
     Value Semantics:  1241844.0 i/s - 3.73x  (± 0.00) slower
              Values:  1194267.0 i/s - 3.87x  (± 0.00) slower
          Dry Struct:   703075.7 i/s - 6.58x  (± 0.00) slower
          OpenStruct:   190743.6 i/s - 24.25x  (± 0.00) slower
