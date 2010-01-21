require 'daemon'
require 'db_model'
require 'sms'
require 'email'

class ProcessNotifier < Daemon::Base
  def self.start
    loop do
		File.open('result.out', 'a') do |f|
			f.puts "==> " << Time.now.to_s
			process_notifiers(f)
		end
		sleep(10)
    end
  end

  def self.stop
    File.open('result', 'a') {|f| f.puts "--- stop ---"}
  end

  def self.process_notifiers(f)
	  ns = Notifier.all(:conditions => "status = 0") 
	  if ns && ns.length>0
		  sms = Sms.instance
		  em  = Email.new
		  ns.each do |n|
			  if (n.ntype == "SMS")
				  r = sms.SendSms(n.address, n.message)
				  if r==0
					  f.puts "Send sms(#{n.id}) to: #{n.address}, message: #{n.message}"
					  n.status = 1
					  n.save
				  else
					  f.puts "Send sms(#{n.id}) error"
				  end
			  end
			  if (n.ntype == "EMAIL")
				  f.puts "Send email(#{n.id}): #{n.address},  subject: #{n.subject}"
				  em.SendEmail(n.address, n.subject, n.message)
				  n.status = 1
				  n.save
			  end
		  end
		  f.puts "------"
	  end
  end
  def self.test
    loop do
		puts "process: " << Time.now.to_s
		process_notifiers
		sleep(10)
    end
  end
end

ProcessNotifier.daemonize
#ProcessNotifier.test

