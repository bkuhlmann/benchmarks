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
        Implicit (<)     2.287M i/100ms
        Implicit (>)     2.296M i/100ms
   Interpolation (<)   629.712k i/100ms
   Interpolation (>)   102.494k i/100ms
              #+ (<)   596.644k i/100ms
              #+ (>)    29.245k i/100ms
         #concat (<)   399.783k i/100ms
         #concat (>)    90.769k i/100ms
             #<< (<)   413.890k i/100ms
             #<< (>)   122.904k i/100ms
      Array#join (<)   358.464k i/100ms
      Array#join (>)    88.466k i/100ms
Calculating -------------------------------------
        Implicit (<)     21.264M (± 4.9%) i/s -    107.485M in   5.067389s
        Implicit (>)     20.780M (± 3.4%) i/s -    105.607M in   5.087911s
   Interpolation (<)      5.562M (± 3.3%) i/s -     28.337M in   5.100727s
   Interpolation (>)    924.232k (± 4.1%) i/s -      4.715M in   5.109650s
              #+ (<)      5.326M (± 3.5%) i/s -     26.849M in   5.047792s
              #+ (>)    272.241k (± 7.1%) i/s -      1.375M in   5.068927s
         #concat (<)      3.445M (± 3.7%) i/s -     17.590M in   5.113979s
         #concat (>)    800.634k (± 7.6%) i/s -      3.994M in   5.013023s
             #<< (<)      3.747M (± 3.7%) i/s -     19.039M in   5.088030s
             #<< (>)      1.107M (± 4.0%) i/s -      5.531M in   5.001731s
      Array#join (<)      3.209M (± 3.1%) i/s -     16.131M in   5.032059s
      Array#join (>)    785.421k (± 3.5%) i/s -      3.981M in   5.074823s

Comparison:
        Implicit (<): 21264015.4 i/s
        Implicit (>): 20779948.5 i/s - same-ish: difference falls within error
   Interpolation (<):  5561634.7 i/s - 3.82x  (± 0.00) slower
              #+ (<):  5325796.6 i/s - 3.99x  (± 0.00) slower
             #<< (<):  3747260.5 i/s - 5.67x  (± 0.00) slower
         #concat (<):  3444625.8 i/s - 6.17x  (± 0.00) slower
      Array#join (<):  3208698.1 i/s - 6.63x  (± 0.00) slower
             #<< (>):  1107459.5 i/s - 19.20x  (± 0.00) slower
   Interpolation (>):   924231.9 i/s - 23.01x  (± 0.00) slower
         #concat (>):   800633.8 i/s - 26.56x  (± 0.00) slower
      Array#join (>):   785420.6 i/s - 27.07x  (± 0.00) slower
              #+ (>):   272241.1 i/s - 78.11x  (± 0.00) slower
