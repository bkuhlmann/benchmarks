# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

list = %w[one two three four five six seven eight nine ten]
pattern = /t/

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "#grep" do
    list.grep pattern
  end

  benchmark.report "#select" do
    list.select { |value| value.match? pattern }
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
               #grep    25.971k i/100ms
             #select    60.217k i/100ms
Calculating -------------------------------------
               #grep    195.371k (±18.3%) i/s -    934.956k in   5.038134s
             #select    496.217k (±20.7%) i/s -      2.348M in   5.100625s

Comparison:
             #select:   496216.9 i/s
               #grep:   195370.7 i/s - 2.54x  (± 0.00) slower
