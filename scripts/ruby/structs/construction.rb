# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"
require "ostruct"

MAX = 1_000_000

ExampleStruct = Struct.new :to, :from

ExampleClass = Class.new do
  attr_reader :to, :from

  def initialize to:, from:
    @to = to
    @from = from
  end
end

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Struct" do
    MAX.times { ExampleStruct[to: "Mike", from: "Mindy"] }
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
              Struct      5.036  (± 0.0%) i/s -     26.000  in   5.165117s
          OpenStruct      0.192  (± 0.0%) i/s -      1.000  in   5.217452s
               Class      4.364  (± 0.0%) i/s -     22.000  in   5.042370s
                Hash     10.015  (± 0.0%) i/s -     50.000  in   5.002598s

Comparison:
                Hash:       10.0 i/s
              Struct:        5.0 i/s - 1.99x  (± 0.00) slower
               Class:        4.4 i/s - 2.29x  (± 0.00) slower
          OpenStruct:        0.2 i/s - 52.25x  (± 0.00) slower
