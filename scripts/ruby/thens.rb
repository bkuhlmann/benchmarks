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
            standard   129.160k i/100ms
                then   101.525k i/100ms
Calculating -------------------------------------
            standard      1.731M (± 7.8%) i/s -      8.654M in   5.034653s
                then      1.587M (± 8.4%) i/s -      7.919M in   5.047628s

Comparison:
            standard:  1731215.7 i/s
                then:  1586638.7 i/s - same-ish: difference falls within error
