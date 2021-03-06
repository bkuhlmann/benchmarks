# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"
require "forwardable"

Person = Class.new do
  def initialize first, last
    @first = first
    @last = last
  end

  def full_name
    "#{first} #{last}"
  end

  private

  attr_reader :first, :last
end

Example = Class.new Person do
  extend Forwardable

  define_method :unbound_full_name, Person.instance_method(:full_name)
  delegate %i[full_name] => :person

  def initialize first, last, person: Person.new(first, last)
    @first = first
    @last = last
    @person = person
  end

  def wrapped_full_name
    person.full_name
  end

  private

  attr_reader :first, :last, :person
end

example = Example.new "Jill", "Doe"

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Wrapped" do
    example.wrapped_full_name
  end

  benchmark.report "Defined" do
    example.unbound_full_name
  end

  benchmark.report "Delegated" do
    example.full_name
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
             Wrapped   662.226k i/100ms
             Defined   769.532k i/100ms
           Delegated   474.200k i/100ms
Calculating -------------------------------------
             Wrapped      6.633M (± 1.1%) i/s -     33.774M in   5.092087s
             Defined      7.741M (± 1.1%) i/s -     39.246M in   5.070731s
           Delegated      4.732M (± 0.6%) i/s -     23.710M in   5.010734s

Comparison:
             Defined:  7740639.5 i/s
             Wrapped:  6633351.8 i/s - 1.17x  (± 0.00) slower
           Delegated:  4732020.7 i/s - 1.64x  (± 0.00) slower
