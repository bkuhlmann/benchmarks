# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"
require "securerandom"

words = Array.new(100_000) { SecureRandom.alphanumeric 10 }
delimiter = " "
text = words.join delimiter
pattern = /\Aa/

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Without Block" do
    text.split(delimiter).select { |word| word.match? pattern }
  end

  benchmark.report "With Block" do
    selections = []
    text.split(delimiter) { |word| selections << word if word.match? pattern }
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
       Without Block    10.000  i/100ms
          With Block    11.000  i/100ms
Calculating -------------------------------------
       Without Block    103.251  (± 1.9%) i/s -    520.000  in   5.037928s
          With Block    112.077  (± 0.9%) i/s -    561.000  in   5.005743s

Comparison:
          With Block:      112.1 i/s
       Without Block:      103.3 i/s - 1.09x  (± 0.00) slower
