# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

Example = Class.new do
  def initialize words
    @words = words
    @first_word = words.first
  end

  def direct_single
    say first_word
  end

  def direct_multiple
    words.each { |word| say word }
  end

  def proc_single
    method(:say).call first_word
  end

  def proc_multiple
    words.each { |word| method(:say).call word }
  end

  def method_to_proc_single
    first_word.then(&method(:say))
  end

  def method_to_proc_multiple
    words.each(&method(:say))
  end

  private

  attr_reader :words, :first_word

  def say phrase
    "You said: #{phrase}."
  end
end

example = Example.new %w[one two three]

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Direct (s)" do
    example.direct_single
  end

  benchmark.report "Direct (m)" do
    example.direct_multiple
  end

  benchmark.report "Proc (s)" do
    example.proc_single
  end

  benchmark.report "Proc (m)" do
    example.proc_multiple
  end

  benchmark.report "Method To Proc (s)" do
    example.method_to_proc_single
  end

  benchmark.report "Method To Proc (m)" do
    example.method_to_proc_multiple
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
          Direct (s)   640.887k i/100ms
          Direct (m)   232.071k i/100ms
            Proc (s)   345.925k i/100ms
            Proc (m)   124.249k i/100ms
  Method To Proc (s)   208.061k i/100ms
  Method To Proc (m)   137.101k i/100ms
Calculating -------------------------------------
          Direct (s)      6.414M (± 0.5%) i/s -     32.685M in   5.096301s
          Direct (m)      2.319M (± 0.3%) i/s -     11.604M in   5.003526s
            Proc (s)      3.444M (± 1.3%) i/s -     17.296M in   5.022878s
            Proc (m)      1.225M (± 2.0%) i/s -      6.212M in   5.074410s
  Method To Proc (s)      2.042M (± 1.7%) i/s -     10.403M in   5.095877s
  Method To Proc (m)      1.371M (± 1.5%) i/s -      6.855M in   4.999989s

Comparison:
          Direct (s):  6413657.8 i/s
            Proc (s):  3444066.2 i/s - 1.86x  (± 0.00) slower
          Direct (m):  2319091.6 i/s - 2.77x  (± 0.00) slower
  Method To Proc (s):  2042021.8 i/s - 3.14x  (± 0.00) slower
  Method To Proc (m):  1371322.2 i/s - 4.68x  (± 0.00) slower
            Proc (m):  1224757.8 i/s - 5.24x  (± 0.00) slower
