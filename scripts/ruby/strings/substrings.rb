# frozen_string_literal: true

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
       #sub (string)   175.035k i/100ms
        #sub (regex)   167.982k i/100ms
      #gsub (string)    85.034k i/100ms
       #gsub (regex)    60.639k i/100ms
                 #tr   250.763k i/100ms
Calculating -------------------------------------
       #sub (string)      3.143M (± 3.8%) i/s -     15.753M in   5.020704s
        #sub (regex)      2.865M (± 2.9%) i/s -     14.446M in   5.046269s
      #gsub (string)      1.448M (± 8.8%) i/s -      7.228M in   5.052658s
       #gsub (regex)    685.752k (± 9.7%) i/s -      3.396M in   5.036171s
                 #tr      5.245M (± 7.5%) i/s -     26.079M in   5.011402s

Comparison:
                 #tr:  5244707.4 i/s
       #sub (string):  3142590.5 i/s - 1.67x  slower
        #sub (regex):  2865411.8 i/s - 1.83x  slower
      #gsub (string):  1447760.2 i/s - 3.62x  slower
       #gsub (regex):   685751.7 i/s - 7.65x  slower
