# frozen_string_literal: true

require "benchmark/ips"

text_1 = "Test"
text_2 = "Example"

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

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
       Interpolation   260.317k i/100ms
            Addition   284.975k i/100ms
       String#concat   207.103k i/100ms
           String#<<   212.497k i/100ms
          Array#join   141.401k i/100ms
Calculating -------------------------------------
       Interpolation      6.039M (± 7.9%) i/s -     29.936M in   5.004322s
            Addition      6.565M (± 8.8%) i/s -     32.487M in   5.003820s
       String#concat      3.686M (± 4.5%) i/s -     18.432M in   5.010922s
           String#<<      3.905M (± 3.5%) i/s -     19.550M in   5.012176s
          Array#join      1.980M (± 7.0%) i/s -      9.898M in   5.028729s

Comparison:
            Addition:  6565359.3 i/s
       Interpolation:  6039397.8 i/s - same-ish: difference falls within error
           String#<<:  3905443.7 i/s - 1.68x  slower
       String#concat:  3686375.1 i/s - 1.78x  slower
          Array#join:  1980095.5 i/s - 3.32x  slower
