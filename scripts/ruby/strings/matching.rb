# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"
require "securerandom"

word = SecureRandom.alphanumeric 100
string_matcher = "a"
regex_matcher = /\Aa/.freeze

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "#match?" do
    word.match? regex_matcher
  end

  benchmark.report "#=~" do
    word =~ regex_matcher
  end

  benchmark.report "#start_with? (String)" do
    word.start_with? string_matcher
  end

  benchmark.report "#start_with? (Regex)" do
    word.start_with? regex_matcher
  end

  benchmark.report "#end_with?" do
    word.end_with? string_matcher
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
             #match?   319.666k i/100ms
                 #=~   177.965k i/100ms
#start_with? (String)
                       338.345k i/100ms
#start_with? (Regex)   177.292k i/100ms
          #end_with?   323.497k i/100ms
Calculating -------------------------------------
             #match?     10.228M (± 3.9%) i/s -     51.147M in   5.008606s
                 #=~      3.008M (± 3.9%) i/s -     15.127M in   5.036687s
#start_with? (String)
                         11.839M (± 4.2%) i/s -     59.210M in   5.010791s
#start_with? (Regex)      2.985M (± 7.6%) i/s -     14.893M in   5.036714s
          #end_with?     10.921M (± 4.8%) i/s -     54.671M in   5.018046s

Comparison:
#start_with? (String): 11839083.3 i/s
          #end_with?: 10921469.3 i/s - same-ish: difference falls within error
             #match?: 10228274.3 i/s - 1.16x  slower
                 #=~:  3008045.0 i/s - 3.94x  slower
#start_with? (Regex):  2984676.3 i/s - 3.97x  slower
