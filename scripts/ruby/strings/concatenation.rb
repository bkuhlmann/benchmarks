# frozen_string_literal: true

require "benchmark/ips"

text_1 = "Test"
text_2 = "Example"

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Interpolation" do
    "#{text_1} #{text_2}"
  end

  benchmark.report "Array#join" do
    [text_1, text_2].join " "
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
       Interpolation   255.322k i/100ms
          Array#join   138.454k i/100ms
Calculating -------------------------------------
       Interpolation      6.083M (± 4.9%) i/s -     30.383M in   5.007666s
          Array#join      1.909M (±13.0%) i/s -      9.415M in   5.032221s

Comparison:
       Interpolation:  6082561.6 i/s
          Array#join:  1909304.9 i/s - 3.19x  slower
