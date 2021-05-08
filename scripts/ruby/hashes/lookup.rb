# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

example = {a: 1, b: 2, c: 3}

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "#[]" do
    example[:b]
  end

  benchmark.report "#fetch" do
    example.fetch :b
  end

  benchmark.report "#fetch (default)" do
    example.fetch :b, "default"
  end

  benchmark.report "#fetch (block)" do
    example.fetch(:b) { "default" }
  end

  benchmark.report "#dig" do
    example.dig :b
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
                 #[]     2.244M i/100ms
              #fetch     1.721M i/100ms
    #fetch (default)     1.714M i/100ms
      #fetch (block)     1.681M i/100ms
                #dig     1.797M i/100ms
Calculating -------------------------------------
                 #[]     21.986M (± 1.0%) i/s -    109.980M in   5.002711s
              #fetch     16.983M (± 0.7%) i/s -     86.044M in   5.066709s
    #fetch (default)     16.893M (± 0.9%) i/s -     85.724M in   5.074970s
      #fetch (block)     16.531M (± 1.1%) i/s -     84.047M in   5.084762s
                #dig     17.941M (± 1.0%) i/s -     89.834M in   5.007847s

Comparison:
                 #[]: 21986220.5 i/s
                #dig: 17940603.8 i/s - 1.23x  (± 0.00) slower
              #fetch: 16983133.0 i/s - 1.29x  (± 0.00) slower
    #fetch (default): 16893042.1 i/s - 1.30x  (± 0.00) slower
      #fetch (block): 16531200.1 i/s - 1.33x  (± 0.00) slower
