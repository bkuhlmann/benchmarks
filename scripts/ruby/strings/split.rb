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
       Without Block     5.000  i/100ms
          With Block     5.000  i/100ms
Calculating -------------------------------------
       Without Block     53.861  (± 7.4%) i/s -    270.000  in   5.058124s
          With Block     58.258  (± 5.1%) i/s -    295.000  in   5.073450s

Comparison:
          With Block:       58.3 i/s
       Without Block:       53.9 i/s - same-ish: difference falls within error
