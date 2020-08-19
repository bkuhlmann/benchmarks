# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

a = %w[one two three]
b = %w[four five six]

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "#+" do
    a + b
  end

  # rubocop:disable Lint/UselessAssignment
  benchmark.report "#+=" do
    duplicate = a.dup
    duplicate += b
  end
  # rubocop:enable Lint/UselessAssignment

  benchmark.report "#concat" do
    a.dup.concat b
  end

  benchmark.report "#|" do
    a | b
  end

  benchmark.report "#<< + #flatten" do
    (a.dup << b).flatten
  end

  benchmark.report "splat + #flatten" do
    [a, *b].flatten
  end

  benchmark.report "multi-splat" do
    [*a, *b]
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
                  #+   457.697k i/100ms
                 #+=   411.714k i/100ms
             #concat   222.004k i/100ms
                  #|   145.737k i/100ms
      #<< + #flatten    60.253k i/100ms
    splat + #flatten    58.633k i/100ms
         multi-splat   282.676k i/100ms
Calculating -------------------------------------
                  #+      4.570M (±21.2%) i/s -     22.427M in   5.017876s
                 #+=      3.742M (± 3.8%) i/s -     18.939M in   5.068411s
             #concat      2.187M (±11.5%) i/s -     10.878M in   5.026729s
                  #|      1.637M (±10.6%) i/s -      8.161M in   5.030635s
      #<< + #flatten    521.165k (± 9.3%) i/s -      2.591M in   5.012084s
    splat + #flatten    520.261k (± 8.5%) i/s -      2.638M in   5.105158s
         multi-splat      2.580M (±16.1%) i/s -     13.003M in   5.124962s

Comparison:
                  #+:  4569764.7 i/s
                 #+=:  3742049.9 i/s - same-ish: difference falls within error
         multi-splat:  2579852.5 i/s - 1.77x  (± 0.00) slower
             #concat:  2186681.7 i/s - 2.09x  (± 0.00) slower
                  #|:  1637445.5 i/s - 2.79x  (± 0.00) slower
      #<< + #flatten:   521164.6 i/s - 8.77x  (± 0.00) slower
    splat + #flatten:   520261.5 i/s - 8.78x  (± 0.00) slower
