#!/usr/bin/env ruby
require 'db_model'

sms = Sms.new
Notifier.all(:conditions => 'status=0').each do |n|
	if sms.SendSms(n.address, n.message)
		n.status = 1
		n.sent_date = Time.now
		n.save
	end
end



