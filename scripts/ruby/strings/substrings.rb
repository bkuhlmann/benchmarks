# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

example = "example"

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "#sub (string)" do
    example.sub "x", "b"
  end

  benchmark.report "#sub (regex)" do
    example.sub(/x/, "b")
  end

  benchmark.report "#gsub (string)" do
    example.gsub "x", "b"
  end

  benchmark.report "#gsub (regex)" do
    example.gsub(/x/, "b")
  end

  benchmark.report "#tr" do
    example.tr "x", "b"
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
       #sub (string)   543.195k i/100ms
        #sub (regex)   490.182k i/100ms
      #gsub (string)   275.943k i/100ms
       #gsub (regex)   144.055k i/100ms
                 #tr   850.367k i/100ms
Calculating -------------------------------------
       #sub (string)      5.358M (± 0.7%) i/s -     27.160M in   5.069344s
        #sub (regex)      4.929M (± 0.6%) i/s -     24.999M in   5.072484s
      #gsub (string)      2.823M (± 3.4%) i/s -     14.349M in   5.087555s
       #gsub (regex)      1.496M (± 7.0%) i/s -      7.491M in   5.027838s
                 #tr      8.531M (± 0.6%) i/s -     43.369M in   5.083958s

Comparison:
                 #tr:  8530843.4 i/s
       #sub (string):  5357905.9 i/s - 1.59x  (± 0.00) slower
        #sub (regex):  4928582.0 i/s - 1.73x  (± 0.00) slower
      #gsub (string):  2823314.1 i/s - 3.02x  (± 0.00) slower
       #gsub (regex):  1495808.3 i/s - 5.70x  (± 0.00) slower
