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
               Splat   579.785k i/100ms
               Merge   443.464k i/100ms
              Merge!   647.672k i/100ms
          Dup Merge!   330.272k i/100ms
Calculating -------------------------------------
               Splat      6.198M (± 4.3%) i/s -     31.308M in   5.060151s
               Merge      4.364M (± 5.2%) i/s -     22.173M in   5.093580s
              Merge!      6.475M (± 5.9%) i/s -     32.384M in   5.016326s
          Dup Merge!      3.286M (± 5.8%) i/s -     16.514M in   5.039714s

Comparison:
              Merge!:  6475365.6 i/s
               Splat:  6197824.0 i/s - same-ish: difference falls within error
               Merge:  4364354.5 i/s - 1.48x  (± 0.00) slower
          Dup Merge!:  3286329.0 i/s - 1.97x  (± 0.00) slower
