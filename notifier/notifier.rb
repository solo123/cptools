require 'db_model'
require 'sms'
require 'email'

class ProcessNotifier 

  def self.process()
	  puts '==> ' << Time.now.to_s
	  ns = Notifier.all(:conditions => "status = 0") 
	  if ns && ns.length>0
		  sms = Sms.instance
		  em  = Email.new
		  ns.each do |n|
			  if (n.ntype == "SMS")
				  r = sms.SendSms(n.address, n.message)
				  if r==0
					  puts "Send sms(#{n.id}) to: #{n.address}, message: #{n.message}"
					  n.status = 1
					  n.save
				  else
					  puts "Send sms(#{n.id}) error"
				  end
			  end
			  if (n.ntype == "EMAIL")
				  puts "Send email(#{n.id}): #{n.address},  subject: #{n.subject}"
				  em.SendEmail(n.address, n.subject, n.message)
				  n.status = 1
				  n.save
			  end
		  end
		  puts "------"
	  end
  end
end

ProcessNotifier.process
