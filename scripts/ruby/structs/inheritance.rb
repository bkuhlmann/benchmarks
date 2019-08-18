# frozen_string_literal: true

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
              Struct      2.090  (± 0.0%) i/s -     11.000  in   5.266773s
            Subclass      2.022  (± 0.0%) i/s -     11.000  in   5.446788s

Comparison:
              Struct:        2.1 i/s
            Subclass:        2.0 i/s - 1.03x  slower
