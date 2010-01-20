require 'daemon'
class Robot < Daemon::Base
  def self.start
    init_all()
    while true
      sleep(500)
    end
  end

  def self.stop
    destory_all()
  end

  puts "hello"
end
