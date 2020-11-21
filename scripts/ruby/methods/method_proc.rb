# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

Example = Class.new do
  def initialize words
    @words = words
    @first_word = words.first
  end

  def single_direct_say
    say first_word
  end

  def multi_direct_say
    words.each { |word| say word }
  end

  def single_proc_say
    method(:say).call first_word
  end

  def multi_proc_say
    words.each { |word| method(:say).call word }
  end

  def single_method_to_proc_say
    first_word.then(&method(:say))
  end

  def multi_method_to_proc_say
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
    example.single_direct_say
  end

  benchmark.report "Direct (m)" do
    example.multi_direct_say
  end

  benchmark.report "Proc (s)" do
    example.single_proc_say
  end

  benchmark.report "Proc (m)" do
    example.multi_proc_say
  end

  benchmark.report "Method To Proc (s)" do
    example.single_method_to_proc_say
  end

  benchmark.report "Method To Proc (m)" do
    example.multi_method_to_proc_say
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
          Direct (s)   466.500k i/100ms
          Direct (m)   150.790k i/100ms
            Proc (s)   178.430k i/100ms
            Proc (m)    57.301k i/100ms
  Method To Proc (s)    89.281k i/100ms
  Method To Proc (m)    60.635k i/100ms
Calculating -------------------------------------
          Direct (s)      4.444M (± 3.3%) i/s -     22.392M in   5.044717s
          Direct (m)      1.310M (± 8.0%) i/s -      6.635M in   5.101708s
            Proc (s)      1.603M (± 5.5%) i/s -      8.029M in   5.022631s
            Proc (m)    513.423k (± 5.9%) i/s -      2.579M in   5.038619s
  Method To Proc (s)    782.483k (± 6.3%) i/s -      3.928M in   5.037407s
  Method To Proc (m)    541.210k (± 6.4%) i/s -      2.729M in   5.061138s

Comparison:
          Direct (s):  4443575.1 i/s
            Proc (s):  1603188.1 i/s - 2.77x  (± 0.00) slower
          Direct (m):  1309656.9 i/s - 3.39x  (± 0.00) slower
  Method To Proc (s):   782482.9 i/s - 5.68x  (± 0.00) slower
  Method To Proc (m):   541209.5 i/s - 8.21x  (± 0.00) slower
            Proc (m):   513423.4 i/s - 8.65x  (± 0.00) slower
