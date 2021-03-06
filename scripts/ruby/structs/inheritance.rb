# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

MAX = 1_000_000

PlotStruct = Struct.new :x, :y

class PlotSubclass < Struct.new :x, :y
end

struct = -> { PlotStruct[x: 1, y: 2] }
subclass = -> { PlotSubclass[x: 1, y: 2] }

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Struct" do
    MAX.times { struct.call }
  end

  benchmark.report "Subclass" do
    MAX.times { subclass.call }
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
              Struct     1.000  i/100ms
            Subclass     1.000  i/100ms
Calculating -------------------------------------
              Struct      4.520  (± 0.0%) i/s -     23.000  in   5.091008s
            Subclass      4.516  (± 0.0%) i/s -     23.000  in   5.094814s

Comparison:
              Struct:        4.5 i/s
            Subclass:        4.5 i/s - 1.00x  (± 0.00) slower
