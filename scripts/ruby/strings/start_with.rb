# frozen_string_literal: true

require "benchmark/ips"
require "securerandom"

word = SecureRandom.alphanumeric 100
string_matcher = "a"
regex_matcher = /\Aa/.freeze

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "String" do
    word.start_with? string_matcher
  end

  benchmark.report "Regular Expression" do
    word.start_with? regex_matcher
  end

  benchmark.report "Match" do
    word.match? regex_matcher
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
              String   317.574k i/100ms
  Regular Expression   174.238k i/100ms
               Match   262.429k i/100ms
Calculating -------------------------------------
              String     10.900M (±16.2%) i/s -     52.400M in   5.002610s
  Regular Expression      2.881M (±11.8%) i/s -     14.288M in   5.039285s
               Match      9.207M (±13.4%) i/s -     45.138M in   5.008261s

Comparison:
              String: 10900378.0 i/s
               Match:  9207095.8 i/s - same-ish: difference falls within error
  Regular Expression:  2880569.2 i/s - 3.78x  slower
