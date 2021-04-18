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
               #grep   172.486k i/100ms
             #select   126.997k i/100ms
Calculating -------------------------------------
               #grep      1.756M (± 2.4%) i/s -      8.797M in   5.011998s
             #select      1.272M (± 3.0%) i/s -      6.477M in   5.096228s

Comparison:
               #grep:  1756126.5 i/s
             #select:  1272013.2 i/s - 1.38x  (± 0.00) slower
