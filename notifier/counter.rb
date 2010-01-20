require 'daemon'
class Counter < Daemon::Base
  def self.start
    @a = 0
    loop do
      @a += 1
	  sleep(10)
    end
  end

  def self.stop
    File.open('result', 'w') {|f| f.puts "a = #{@a}"}
  end
end

Counter.daemonize
