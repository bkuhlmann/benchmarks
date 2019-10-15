# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

Example = Class.new do
  def echo_implicit text
    yield
    text
  end

  def echo_implicit_guard text
    yield if block_given?
    text
  end

  def echo_explicit text, &block
    yield block
    text
  end

  def echo_explicit_guard text, &block
    yield block if block
    text
  end
end

block_example = Example.new
lambda_example = ->(text) { text }
proc_example = proc { |text| text }

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Block (implicit)" do
    block_example.echo_implicit("hi") { "test" }
  end

  benchmark.report "Block (implicit guard)" do
    block_example.echo_implicit_guard("hi") { "test" }
  end

  benchmark.report "Block (explicit)" do
    block_example.echo_explicit("hi") { "test" }
  end

  benchmark.report "Block (explicit guard)" do
    block_example.echo_explicit_guard("hi") { "test" }
  end

  benchmark.report "Lambda" do
    lambda_example.call "test"
  end

  benchmark.report "Proc" do
    proc_example.call "test"
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
    Block (implicit)   363.125k i/100ms
Block (implicit guard)
                       329.634k i/100ms
    Block (explicit)   137.856k i/100ms
Block (explicit guard)
                       141.157k i/100ms
              Lambda   362.908k i/100ms
                Proc   365.367k i/100ms
Calculating -------------------------------------
    Block (implicit)     12.973M (± 4.7%) i/s -     64.999M in   5.022696s
Block (implicit guard)
                         10.000M (± 4.7%) i/s -     50.104M in   5.022405s
    Block (explicit)      1.865M (±14.2%) i/s -      9.236M in   5.050631s
Block (explicit guard)
                          1.806M (±15.1%) i/s -      8.893M in   5.018571s
              Lambda     13.902M (± 5.4%) i/s -     69.315M in   5.001246s
                Proc     13.960M (± 5.4%) i/s -     69.785M in   5.013967s

Comparison:
                  Proc: 13959561.8 i/s
                Lambda: 13901543.3 i/s - same-ish: difference falls within error
      Block (implicit): 12972643.5 i/s - same-ish: difference falls within error
Block (implicit guard): 10000074.6 i/s - 1.40x  slower
      Block (explicit): 1864599.3 i/s - 7.49x  slower
Block (explicit guard): 1805793.9 i/s - 7.73x  slower
