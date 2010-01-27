
if ARGV.length < 1
	puts "Usage: #{$0} [path] [-f]"
	Process.exit
end

flag_force = (ARGV[1] == "-f")
puts "Update to database: " << flag_force.to_s

Dir.chdir ARGV[0]
`ls -d */`.split("\n").each do |brandline|
		brand = brandline.chop
		puts ">> Brand: " << brand
		`ls -d #{brandline}*/`.split("\n").each do |modeline|
			s = modeline.scan(/\/(.*)\//)
			if s && s.length > 0
				model = s[0].to_s
				newname = model.scan(/#{brand}(.*)/i).to_s.strip.upcase
                if newname.length > 0				
					if flag_force
						`mv "#{brand}/#{model}" "#{brand}/#{newname}"`
					end
					print "(#{brand}-#{model}:#{newname}), "
				else
					print "#{model}, "
				end
			end
		end
		puts ""
end


