require 'net/smtp'
require 'base64'

class Email
	def SendEmail(to_email, subject, message)

		_sub = Base64.b64encode(subject)
		msg = <<MESSAGE_END
From: coolpur.com <service@coolpur.cn>
To:  <#{to_email}>
MIME-Version: 1.0
Content-type: text/plain;charset=utf-8
Subject:=?UTF-8?B?#{_sub.rstrip}?=

#{message}
MESSAGE_END
		Net::SMTP.start('lcalhost', 25) do |smtp|
			smtp.send_message msg, 'service@coolpur.cn', to_email
		end
	end

end

Email.new.SendEmail('solo123@21cn.com', '测试邮件', '这是一封测试邮件\n第二行\nRegards,\nJimmy Liang')
