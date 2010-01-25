#!/usr/bin/env ruby

require 'db_model'
require 'sms'
require 'email'

class ProcessNotifier 

	def self.process()
		sms = Sms.new
		em  = Email.new
		File.open('notifier.out','a') do |f|
			f.puts ' ==> ' << Time.now.to_s
			Notifier.all(:conditions => "status = 0").each do |n|
				if (n.ntype == "SMS")
					r = sms.SendSms(n.address, n.message)
					if r==0
						f.puts "Send sms(#{n.id}) to: #{n.address}, message: #{n.message}"
						n.sent_date = Time.now
						n.status = 1
						n.save
					else
						f.puts "Send sms(#{n.id}) error"
					end
				end
				if (n.ntype == "EMAIL")
					f.puts "Send email(#{n.id}): #{n.address},  subject: #{n.subject}"
					em.SendEmail(n.address, n.subject, n.message)
					n.sent_date = Time.now
					n.status = 1
					n.save
				end
			end
		end
	end
end

ProcessNotifier.process

