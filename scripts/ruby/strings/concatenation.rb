# frozen_string_literal: true

require "bundler/setup"
require "benchmark/ips"

one = "One"
two = "Two"
three = "Three"
four = "Four"
five = "Five"
six = "Six"
seven = "Seven"
eight = "Eight"
nine = "Nine"
ten = "Ten"

Benchmark.ips do |benchmark|
  benchmark.config time: 5, warmup: 2

  benchmark.report "Implicit (<)" do
    "One" "Two"
  end

  benchmark.report "Implicit (>)" do
    "One" "Two" "Three" "Four" "Five" "Six" "Seven" "Eight" "Nine" "Ten"
  end

  benchmark.report "Interpolation (<)" do
    "#{one} #{two}"
  end

  benchmark.report "Interpolation (>)" do
    "#{one} #{two} #{three} #{four} #{five} #{six} #{seven} #{eight} #{nine} #{ten}"
  end

  benchmark.report "#+ (<)" do
    one + " " + two
  end

  benchmark.report "#+ (>)" do
    one + " " + two + " " + three + " " + four + " " + five + " " + six + " " + seven + " " +
    eight + " " + nine + " " + ten
  end

  # WARNING: Mutation.
  benchmark.report "#concat (<)" do
    one.dup.concat two
  end

  # WARNING: Mutation.
  benchmark.report "#concat (>)" do
    one.dup.concat two, three, four, five, six, seven, eight, nine, ten
  end

  # WARNING: Mutation.
  benchmark.report "#<< (<)" do
    one.dup << two
  end

  # WARNING: Mutation.
  benchmark.report "#<< (>)" do
    one.dup << two << three << four << five << six << seven << eight << nine << ten
  end

  benchmark.report "Array#join (<)" do
    [one, two].join " "
  end

  benchmark.report "Array#join (>)" do
    [one, two, three, four, five, six, seven, eight, nine, ten].join " "
  end

  benchmark.compare!
end

__END__

Warming up --------------------------------------
        Implicit (<)     2.547M i/100ms
        Implicit (>)     2.631M i/100ms
   Interpolation (<)     1.029M i/100ms
   Interpolation (>)   177.439k i/100ms
              #+ (<)   832.046k i/100ms
              #+ (>)    64.009k i/100ms
         #concat (<)   655.630k i/100ms
         #concat (>)   165.794k i/100ms
             #<< (<)   694.881k i/100ms
             #<< (>)   222.725k i/100ms
      Array#join (<)   626.380k i/100ms
      Array#join (>)   160.694k i/100ms
Calculating -------------------------------------
        Implicit (<)     26.270M (± 1.2%) i/s -    132.422M in   5.041494s
        Implicit (>)     26.336M (± 1.6%) i/s -    134.170M in   5.095723s
   Interpolation (<)     10.282M (± 0.6%) i/s -     51.460M in   5.005210s
   Interpolation (>)      1.735M (± 3.1%) i/s -      8.695M in   5.016475s
              #+ (<)      9.381M (± 1.0%) i/s -     47.427M in   5.055867s
              #+ (>)    647.293k (± 3.5%) i/s -      3.264M in   5.048841s
         #concat (<)      6.562M (± 0.6%) i/s -     33.437M in   5.095572s
         #concat (>)      1.764M (± 4.0%) i/s -      8.953M in   5.082208s
             #<< (<)      7.000M (± 0.6%) i/s -     35.439M in   5.062862s
             #<< (>)      2.221M (± 2.9%) i/s -     11.136M in   5.017108s
      Array#join (<)      6.252M (± 0.7%) i/s -     31.319M in   5.009523s
      Array#join (>)      1.614M (± 2.2%) i/s -      8.195M in   5.080520s

Comparison:
        Implicit (>): 26336350.5 i/s
        Implicit (<): 26270214.9 i/s - same-ish: difference falls within error
   Interpolation (<): 10281710.4 i/s - 2.56x  (± 0.00) slower
              #+ (<):  9381456.8 i/s - 2.81x  (± 0.00) slower
             #<< (<):  7000016.4 i/s - 3.76x  (± 0.00) slower
         #concat (<):  6562217.6 i/s - 4.01x  (± 0.00) slower
      Array#join (<):  6252228.2 i/s - 4.21x  (± 0.00) slower
             #<< (>):  2221388.2 i/s - 11.86x  (± 0.00) slower
         #concat (>):  1764070.7 i/s - 14.93x  (± 0.00) slower
   Interpolation (>):  1734732.3 i/s - 15.18x  (± 0.00) slower
      Array#join (>):  1613872.9 i/s - 16.32x  (± 0.00) slower
              #+ (>):   647292.9 i/s - 40.69x  (± 0.00) slower
