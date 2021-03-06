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
           .delegate   770.615k i/100ms
     SimpleDelegator   262.759k i/100ms
       DelegateClass   545.888k i/100ms
Calculating -------------------------------------
           .delegate      7.585M (± 0.6%) i/s -     38.531M in   5.080172s
     SimpleDelegator      2.661M (± 1.3%) i/s -     13.401M in   5.036776s
       DelegateClass      5.447M (± 0.6%) i/s -     27.294M in   5.011068s

Comparison:
           .delegate:  7584844.9 i/s
       DelegateClass:  5447021.8 i/s - 1.39x  (± 0.00) slower
     SimpleDelegator:  2661020.2 i/s - 2.85x  (± 0.00) slower
