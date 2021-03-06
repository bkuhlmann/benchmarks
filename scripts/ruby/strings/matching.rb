# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"
require "securerandom"

word = SecureRandom.alphanumeric 100
string_matcher = "a"
regex_matcher = /\Aa/

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
             #match?     1.446M i/100ms
                 #=~   748.378k i/100ms
#start_with? (String)
                         1.521M i/100ms
#start_with? (Regex)   672.990k i/100ms
          #end_with?     1.473M i/100ms
Calculating -------------------------------------
             #match?     14.216M (± 0.5%) i/s -     72.314M in   5.086920s
                 #=~      7.142M (± 2.4%) i/s -     35.922M in   5.032710s
#start_with? (String)
                         15.027M (± 0.3%) i/s -     76.067M in   5.062133s
#start_with? (Regex)      6.322M (± 2.0%) i/s -     31.631M in   5.005092s
          #end_with?     14.821M (± 0.6%) i/s -     75.143M in   5.070323s

Comparison:
#start_with? (String): 15026855.4 i/s
          #end_with?: 14820633.2 i/s - 1.01x  (± 0.00) slower
             #match?: 14216141.3 i/s - 1.06x  (± 0.00) slower
                 #=~:  7141893.3 i/s - 2.10x  (± 0.00) slower
#start_with? (Regex):  6322083.6 i/s - 2.38x  (± 0.00) slower
