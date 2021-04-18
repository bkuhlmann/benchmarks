# frozen_string_literal: true

require "benchmark/ips"

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "standard" do
    one, two = "one two".split
    "#{one} + #{two} = #{one + two}"
  end

  benchmark.report "then" do
    "one two".split.then { |one, two| "#{one} + #{two} = #{one + two}" }
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
            standard   339.158k i/100ms
                then   309.907k i/100ms
Calculating -------------------------------------
            standard      3.379M (± 0.9%) i/s -     16.958M in   5.018758s
                then      3.084M (± 0.9%) i/s -     15.495M in   5.024083s

Comparison:
            standard:  3379176.5 i/s
                then:  3084483.1 i/s - 1.10x  (± 0.00) slower
