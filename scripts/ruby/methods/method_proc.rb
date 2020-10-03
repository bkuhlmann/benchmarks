# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

WORD = "hello"

Example = Class.new do
  def self.direct_say
    say WORD
  end

  def self.proc_say
    method(:say).call WORD
  end

  def self.say word
    "Example says: #{word}."
  end
end

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Direct" do
    Example.direct_say
  end

  benchmark.report "Proc" do
    Example.proc_say
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
              Direct   239.276k i/100ms
                Proc   140.720k i/100ms
Calculating -------------------------------------
              Direct      5.307M (± 6.0%) i/s -     26.560M in   5.025382s
                Proc      2.033M (± 6.5%) i/s -     10.132M in   5.005368s

Comparison:
              Direct:  5306996.8 i/s
                Proc:  2033254.9 i/s - 2.61x  slower
