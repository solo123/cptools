require 'net/smtp'

class Email
	def SendEmail(to_email, subject, message)
		msgstr = <<END_OF_MESSAGE
From: 酷购客服 <service@coolpur.cn>
To:  <#{to_email}>
Subject: #{subject}
Date: #{Time.now}
Message-Id: <unique.message.id.string@example.com>

    #{message}
END_OF_MESSAGE

    	Net::SMTP.start('mail.coolpur.cn', 25) do |smtp|
      		smtp.send_message msgstr, 'service@coolpur.cn', to_email
	    end
	end

end

Email.new.SendEmail('solo123@21cn.com', '测试邮件', '这是一封测试邮件\n第二行\nRegards,\nJimmy Liang')
