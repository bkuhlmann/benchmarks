# frozen_string_literal: true

require "benchmark/ips"
require "ostruct"

MAX = 1_000_000

ExampleStruct = Struct.new :to, :from

class ExampleClass
  attr_reader :to, :from

  def initialize to:, from:
    @to = to
    @from = from
  end
end

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Struct" do
    MAX.times { ExampleStruct.new to: "Mike", from: "Mindy" }
  end

  benchmark.report "OpenStruct" do
    MAX.times { OpenStruct.new to: "Mike", from: "Mindy" }
  end

  benchmark.report "Class" do
    MAX.times { ExampleClass.new to: "Mike", from: "Mindy" }
  end

  benchmark.report "Hash" do
    MAX.times { {to: "Mike", from: "Mindy"} }
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
              Struct     1.000  i/100ms
          OpenStruct     1.000  i/100ms
               Class     1.000  i/100ms
                Hash     1.000  i/100ms
Calculating -------------------------------------
              Struct      1.976  (± 0.0%) i/s -     10.000  in   5.149870s
          OpenStruct      0.906  (± 0.0%) i/s -      5.000  in   5.631735s
               Class      1.106  (± 0.0%) i/s -      6.000  in   5.436882s
                Hash      3.601  (± 0.0%) i/s -     18.000  in   5.007363s

Comparison:
                Hash:        3.6 i/s
              Struct:        2.0 i/s - 1.82x  slower
               Class:        1.1 i/s - 3.26x  slower
          OpenStruct:        0.9 i/s - 3.98x  slower
