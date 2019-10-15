# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

example = {
  a: 1,
  b: 2,
  c: 3
}

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
                 #[]   375.416k i/100ms
              #fetch   366.082k i/100ms
    #fetch (default)   354.917k i/100ms
      #fetch (block)   357.727k i/100ms
                #dig   349.634k i/100ms
Calculating -------------------------------------
                 #[]     19.604M (± 6.4%) i/s -     97.608M in   5.002071s
              #fetch     14.924M (± 4.0%) i/s -     74.681M in   5.013259s
    #fetch (default)     13.611M (± 4.7%) i/s -     68.144M in   5.019503s
      #fetch (block)     13.326M (± 7.1%) i/s -     66.179M in   5.006153s
                #dig     14.981M (± 5.7%) i/s -     74.822M in   5.012374s

Comparison:
                 #[]: 19604099.2 i/s
                #dig: 14981167.4 i/s - 1.31x  slower
              #fetch: 14923916.7 i/s - 1.31x  slower
    #fetch (default): 13611323.6 i/s - 1.44x  slower
      #fetch (block): 13325886.9 i/s - 1.47x  slower
