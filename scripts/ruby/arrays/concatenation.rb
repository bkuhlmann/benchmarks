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

  benchmark.compare!
end

__END__

Warming up --------------------------------------
                  #+   233.885k i/100ms
                 #+=   203.519k i/100ms
             #concat   145.623k i/100ms
                  #|   128.432k i/100ms
      #<< + #flatten    45.658k i/100ms
    splat + #flatten    49.643k i/100ms
Calculating -------------------------------------
                  #+      4.551M (± 8.4%) i/s -     22.687M in   5.020530s
                 #+=      3.519M (± 3.4%) i/s -     17.706M in   5.036935s
             #concat      2.124M (±17.4%) i/s -     10.339M in   5.017638s
                  #|      1.719M (±14.4%) i/s -      8.477M in   5.036505s
      #<< + #flatten    511.798k (±15.9%) i/s -      2.511M in   5.014936s
    splat + #flatten    540.469k (±15.2%) i/s -      2.681M in   5.051894s

Comparison:
                  #+:  4551193.4 i/s
                 #+=:  3519429.7 i/s - 1.29x  slower
             #concat:  2124293.9 i/s - 2.14x  slower
                  #|:  1718510.1 i/s - 2.65x  slower
    splat + #flatten:   540468.6 i/s - 8.42x  slower
      #<< + #flatten:   511798.5 i/s - 8.89x  slower
