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
          Direct (s)   737.120k i/100ms
          Direct (m)   267.719k i/100ms
            Proc (s)   349.044k i/100ms
            Proc (m)   122.588k i/100ms
  Method To Proc (s)   185.665k i/100ms
  Method To Proc (m)   137.666k i/100ms
Calculating -------------------------------------
          Direct (s)      7.391M (± 1.0%) i/s -     37.593M in   5.087103s
          Direct (m)      2.666M (± 1.0%) i/s -     13.386M in   5.021959s
            Proc (s)      3.445M (± 2.5%) i/s -     17.452M in   5.068574s
            Proc (m)      1.200M (± 2.6%) i/s -      6.007M in   5.010571s
  Method To Proc (s)      1.867M (± 3.5%) i/s -      9.469M in   5.077309s
  Method To Proc (m)      1.339M (± 3.0%) i/s -      6.746M in   5.040639s

Comparison:
          Direct (s):  7390579.1 i/s
            Proc (s):  3445035.9 i/s - 2.15x  (± 0.00) slower
          Direct (m):  2665754.8 i/s - 2.77x  (± 0.00) slower
  Method To Proc (s):  1867035.7 i/s - 3.96x  (± 0.00) slower
  Method To Proc (m):  1339351.2 i/s - 5.52x  (± 0.00) slower
            Proc (m):  1199565.8 i/s - 6.16x  (± 0.00) slower
