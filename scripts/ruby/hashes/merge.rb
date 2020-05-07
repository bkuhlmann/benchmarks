# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

extra = {b: 2}

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Splat" do
    {a: 1, **extra}
  end

  benchmark.report "Merge" do
    {a: 1}.merge extra
  end

  benchmark.report "Merge!" do
    {a: 1}.merge! extra
  end

  benchmark.report "Dup Merge!" do
    {a: 1}.dup.merge! extra
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
               Splat   144.638k i/100ms
               Merge   123.591k i/100ms
              Merge!   171.197k i/100ms
          Dup Merge!    98.779k i/100ms
Calculating -------------------------------------
               Splat      2.738M (±15.2%) i/s -     13.451M in   5.024280s
               Merge      1.772M (±25.1%) i/s -      8.651M in   5.090233s
              Merge!      2.795M (±13.3%) i/s -     13.867M in   5.051995s
          Dup Merge!      1.448M (±16.9%) i/s -      7.112M in   5.004984s

Comparison:
              Merge!:  2795412.8 i/s
               Splat:  2738338.0 i/s - same-ish: difference falls within error
               Merge:  1771976.9 i/s - 1.58x  slower
          Dup Merge!:  1447942.4 i/s - 1.93x  slower
