require 'db_model'
require 'sms'
require 'email'

class ProcessNotifier 

  def self.process()
	  sms = Sms.new
	  em  = Email.new
	  loop do
	  log ' ==> ' << Time.now.to_s
	  ns = Notifier.all(:conditions => "status = 0") 
	  if ns && ns.length>0
		  ns.each do |n|
			  if (n.ntype == "SMS")
				  r = sms.SendSms(n.address, n.message)
				  if r==0
					  log "Send sms(#{n.id}) to: #{n.address}, message: #{n.message}"
					  n.sent_date = Time.now
					  n.status = 1
					  n.save
				  else
					  log "Send sms(#{n.id}) error"
				  end
			  end
			  if (n.ntype == "EMAIL")
				  log "Send email(#{n.id}): #{n.address},  subject: #{n.subject}"
				  em.SendEmail(n.address, n.subject, n.message)
				  n.sent_date = Time.now
				  n.status = 1
				  n.save
			  end
		  end
		  log ' ---e---- \n'
	  end

	  sleep(10)
	  end
  end

  def self.log(message)
	  File.open('notifier.out','a') do |f|
		  f.puts message
	  end
  end
end

ProcessNotifier.process

