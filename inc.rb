STDOUT.sync = true

Signal.trap("TERM") do
  say "exiting"
  exit
end

def say msg
  puts "\t[inc] #{Time.now.strftime("%T")} #{$$} #{msg}"
end

class Inc
  def initialize file
    @file = file
  end

  def run
    launched = Time.now.to_i
    say "launching in #{File.dirname(@file)}"
    i = 0
    while i < 100
      say "writing #{launched}/#{i} to #{File.basename(@file)}"
      # Publish a complete snapshot so readers never see a truncated file.
      temporary_file = "#{@file}.#{$$}.tmp"
      File.open(temporary_file, "w") do |f|
        f.puts(launched)
        f.puts(i)
        f.puts($$)
        f.puts(Process.ppid)
      end
      File.rename(temporary_file, @file)
      sleep 0.5
      i+=1
    end

  end
end

Inc.new(ARGV[0] || "./inc.txt").run
