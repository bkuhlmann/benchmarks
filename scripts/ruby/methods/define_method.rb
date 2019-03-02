# frozen_string_literal: true

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
             Wrapped   229.882k i/100ms
             Defined   233.064k i/100ms
           Delegated   191.248k i/100ms
Calculating -------------------------------------
             Wrapped      4.765M (± 4.5%) i/s -     23.908M in   5.028370s
             Defined      4.979M (± 5.9%) i/s -     24.938M in   5.027629s
           Delegated      3.081M (± 4.1%) i/s -     15.491M in   5.035950s

Comparison:
             Defined:  4979374.1 i/s
             Wrapped:  4764772.8 i/s - same-ish: difference falls within error
           Delegated:  3081388.7 i/s - 1.62x  slower
