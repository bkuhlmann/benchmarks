# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"
require "delegate"
require "forwardable"

class Example
  def test
    "This is a test."
  end
end

class MacroExample
  extend Forwardable

  delegate %i[test] => :object

  def initialize object
    @object = object
  end

  private

  attr_reader :object
end

class SimpleExample < SimpleDelegator
end

class ClassExample < DelegateClass Example
end

example = Example.new
macro_example = MacroExample.new example
simple_example = SimpleExample.new example
class_example = ClassExample.new example

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report ".delegate" do
    macro_example.test
  end

  benchmark.report "SimpleDelegator" do
    simple_example.test
  end

  benchmark.report "DelegateClass" do
    class_example.test
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
           .delegate   236.239k i/100ms
     SimpleDelegator   119.178k i/100ms
       DelegateClass   183.086k i/100ms
Calculating -------------------------------------
           .delegate      4.948M (± 4.9%) i/s -     24.805M in   5.026020s
     SimpleDelegator      1.633M (± 3.7%) i/s -      8.223M in   5.043243s
       DelegateClass      2.996M (± 3.9%) i/s -     15.013M in   5.018692s

Comparison:
           .delegate:  4947613.2 i/s
       DelegateClass:  2996102.6 i/s - 1.65x  slower
     SimpleDelegator:  1632850.2 i/s - 3.03x  slower
