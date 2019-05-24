# frozen_string_literal: true

require "benchmark/ips"

text_1 = "Test"
text_2 = "Example"

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Implicit" do
    "Test" "Example"
  end

  benchmark.report "Interpolation" do
    "#{text_1} #{text_2}"
  end

  benchmark.report "Addition" do
    text_1 + " " + text_2
  end

  # WARNING: Mutation.
  benchmark.report "String#concat" do
    text_1.dup.concat text_2
  end

  # WARNING: Mutation.
  benchmark.report "String#<<" do
    text_1.dup << text_2
  end

  benchmark.report "Array#join" do
    [text_1, text_2].join " "
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
            Implicit   409.598k i/100ms
       Interpolation   253.230k i/100ms
            Addition   276.776k i/100ms
       String#concat   208.632k i/100ms
           String#<<   210.205k i/100ms
          Array#join   137.953k i/100ms
Calculating -------------------------------------
            Implicit     26.189M (± 4.9%) i/s -    130.662M in   5.002351s
       Interpolation      6.073M (± 4.2%) i/s -     30.388M in   5.013407s
            Addition      6.676M (± 4.4%) i/s -     33.490M in   5.026986s
       String#concat      3.548M (± 9.5%) i/s -     17.525M in   5.009926s
           String#<<      3.684M (± 5.7%) i/s -     18.498M in   5.039367s
          Array#join      1.944M (± 6.7%) i/s -      9.795M in   5.062777s

Comparison:
            Implicit: 26189407.1 i/s
            Addition:  6675827.8 i/s - 3.92x  slower
       Interpolation:  6072734.5 i/s - 4.31x  slower
           String#<<:  3683995.3 i/s - 7.11x  slower
       String#concat:  3547868.6 i/s - 7.38x  slower
          Array#join:  1944381.0 i/s - 13.47x  slower
