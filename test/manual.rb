require_relative '../lib/fitreader/fit'
require 'benchmark/ips'

p = "test/files/working_garmin.fit"
Benchmark.ips do |x|
  # Configure the number of seconds used during
  # the warmup phase (default 2) and calculation phase (default 5)
  x.config(:time => 30, :warmup => 2)

  # Typical mode, runs the block as many times as it can
  # x.report("addition") { 1 + 2 }

  # To reduce overhead, the number of iterations is passed in
  # and the block must run the code the specific number of times.
  # Used for when the workload is very small and any overhead
  # introduces incorrectable errors.
  x.report("single_run") do |times|
    f = File.open(p, "r")
    Fit.new f
  end

  # Compare the iterations per second of the various reports!
  x.compare!
end
