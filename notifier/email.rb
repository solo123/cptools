require 'net/smtp'
require 'base64'

class Email
	def SendEmail(to_email, subject, message)

		_sub = Base64.encode64(subject)
		msg = <<MESSAGE_END
From: "酷购.客服" <service@coolpur.cn>
To:  <#{to_email}>
MIME-Version: 1.0
Content-type: text/plain;charset=utf-8
Subject:=?UTF-8?B?#{_sub.rstrip}?=

#{message}
MESSAGE_END
		Net::SMTP.start('localhost', 25) do |smtp|
			smtp.send_message msg, 'service@coolpur.cn', to_email
		end
	end

end

