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
    Block (implicit)     1.445M i/100ms
Block (implicit guard)
                         1.208M i/100ms
    Block (explicit)   402.677k i/100ms
Block (explicit guard)
                       394.207k i/100ms
              Lambda     1.657M i/100ms
                Proc     1.686M i/100ms
Calculating -------------------------------------
    Block (implicit)     14.320M (± 1.0%) i/s -     72.268M in   5.047006s
Block (implicit guard)
                         11.985M (± 0.5%) i/s -     60.393M in   5.039127s
    Block (explicit)      3.996M (± 5.4%) i/s -     20.134M in   5.051219s
Block (explicit guard)
                          3.939M (± 5.2%) i/s -     19.710M in   5.015816s
              Lambda     16.673M (± 0.4%) i/s -     84.509M in   5.068818s
                Proc     16.589M (± 0.4%) i/s -     84.309M in   5.082291s

Comparison:
              Lambda: 16672549.1 i/s
                Proc: 16589090.1 i/s - same-ish: difference falls within error
    Block (implicit): 14320229.3 i/s - 1.16x  (± 0.00) slower
Block (implicit guard): 11985042.8 i/s - 1.39x  (± 0.00) slower
    Block (explicit):  3995551.0 i/s - 4.17x  (± 0.00) slower
Block (explicit guard):  3938951.4 i/s - 4.23x  (± 0.00) slower
