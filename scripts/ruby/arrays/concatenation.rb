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
                  #+   858.350k i/100ms
                 #+=   648.534k i/100ms
             #concat   442.292k i/100ms
                  #|   350.340k i/100ms
      #<< + #flatten   114.235k i/100ms
    splat + #flatten   134.050k i/100ms
         multi-splat   620.508k i/100ms
Calculating -------------------------------------
                  #+      8.618M (± 2.9%) i/s -     43.776M in   5.083425s
                 #+=      6.564M (± 0.9%) i/s -     33.075M in   5.039315s
             #concat      4.648M (± 5.0%) i/s -     23.441M in   5.055962s
                  #|      3.444M (± 5.2%) i/s -     17.517M in   5.100569s
      #<< + #flatten      1.283M (± 7.3%) i/s -      6.397M in   5.009864s
    splat + #flatten      1.330M (± 4.8%) i/s -      6.702M in   5.050733s
         multi-splat      6.058M (± 1.9%) i/s -     30.405M in   5.020268s

Comparison:
                  #+:  8618252.7 i/s
                 #+=:  6563914.2 i/s - 1.31x  (± 0.00) slower
         multi-splat:  6058493.9 i/s - 1.42x  (± 0.00) slower
             #concat:  4647603.4 i/s - 1.85x  (± 0.00) slower
                  #|:  3443510.5 i/s - 2.50x  (± 0.00) slower
    splat + #flatten:  1329722.1 i/s - 6.48x  (± 0.00) slower
      #<< + #flatten:  1282750.5 i/s - 6.72x  (± 0.00) slower
