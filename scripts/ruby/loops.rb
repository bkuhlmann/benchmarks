# frozen_string_literal: true

require "benchmark/ips"

collection = (1..1_000).to_a
sum = 0

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "for" do
    for number in collection do
      sum += number
    end
  end

  benchmark.report "#each" do
    collection.each { |number| sum += number }
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
                 for     3.326k i/100ms
               #each     3.462k i/100ms
Calculating -------------------------------------
                 for     33.135k (± 0.1%) i/s -    166.300k in   5.018799s
               #each     35.332k (± 0.6%) i/s -    180.024k in   5.095360s

Comparison:
               #each:    35332.2 i/s
                 for:    33135.5 i/s - 1.07x  (± 0.00) slower
