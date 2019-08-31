# frozen_string_literal: true

require "benchmark/ips"

example = {b: 2}

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Splat" do
    {a: 1, **example}
  end

  benchmark.report "Merge" do
    {a: 1}.merge example
  end

  benchmark.report "Merge!" do
    {a: 1}.merge! example
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
               Splat   169.554k i/100ms
               Merge   134.537k i/100ms
              Merge!   188.759k i/100ms
Calculating -------------------------------------
               Splat      2.937M (±27.7%) i/s -     13.903M in   5.040145s
               Merge      1.866M (±20.1%) i/s -      9.149M in   5.058798s
              Merge!      3.031M (±23.3%) i/s -     14.534M in   5.014792s

Comparison:
              Merge!:  3031078.9 i/s
               Splat:  2936693.7 i/s - same-ish: difference falls within error
               Merge:  1866417.7 i/s - 1.62x  slower
