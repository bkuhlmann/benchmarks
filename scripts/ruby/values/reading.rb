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
              Struct     2.063M i/100ms
          OpenStruct     1.245M i/100ms
          Dry Struct     1.691M i/100ms
              Values     2.162M i/100ms
     Value Semantics     1.971M i/100ms
Calculating -------------------------------------
              Struct     20.409M (± 1.0%) i/s -    103.159M in   5.055048s
          OpenStruct     12.337M (± 0.6%) i/s -     62.250M in   5.045816s
          Dry Struct     16.759M (± 0.1%) i/s -     84.547M in   5.044793s
              Values     21.725M (± 0.3%) i/s -    110.283M in   5.076286s
     Value Semantics     19.885M (± 0.8%) i/s -    100.514M in   5.055095s

Comparison:
              Values: 21725412.5 i/s
              Struct: 20409006.1 i/s - 1.06x  (± 0.00) slower
     Value Semantics: 19885038.3 i/s - 1.09x  (± 0.00) slower
          Dry Struct: 16759259.0 i/s - 1.30x  (± 0.00) slower
          OpenStruct: 12337377.7 i/s - 1.76x  (± 0.00) slower
