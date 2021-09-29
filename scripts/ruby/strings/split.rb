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
    text.split(delimiter).grep(pattern)
  end

  benchmark.report "With Block" do
    selections = []
    text.split(delimiter) { |word| selections << word if word.match? pattern }
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
       Without Block    14.000  i/100ms
          With Block    11.000  i/100ms
Calculating -------------------------------------
       Without Block    141.248  (± 1.4%) i/s -    714.000  in   5.055685s
          With Block    114.756  (± 0.9%) i/s -    583.000  in   5.080980s

Comparison:
       Without Block:      141.2 i/s
          With Block:      114.8 i/s - 1.23x  (± 0.00) slower
