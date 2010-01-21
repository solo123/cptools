class Tt
	def tt
			i = 0;
			loop do
				i += 1
				File.open('t.out','a') { |f|
					f.puts "cnt -> " << i.to_s << "  " << Time.now.to_s
				}
				sleep(2)
			end
	end
end

Tt.new.tt
