require "../public/db_connection"

class Brand < CoolpurDB
end
class Mobile < CoolpurDB
end


def add_brand(brand)
	b = Brand.find(:first,:conditions => "brand_name='#{brand}'")
	if b
		return b.id
	end
	b = Brand.new
	b.short_name = b.brand_name = brand
	b.status = 0
	b.save!
	return b.id
end
def add_model(brand,model)
	if brand>0
		mn = model.to_s.upcase
		m = Mobile.find(:first, :conditions => "brand_id=#{brand} and model='#{mn}'")
		if !m
			b = Brand.find(brand)
			mb = Mobile.new
			mb.brand_id = brand
			mb.model = mn
			mb.name = b.brand_name + mn
			mb.price = 0
			mb.status = 0
			mb.save!
			printf "(add:#{brand}-#{mn})"
		end
	end
end





if ARGV.length < 1
	puts "Usage: #{$0} [path] [-f]"
	Process.exit
end

flag_force = (ARGV[1] == "-f")
puts "Update to database: " << flag_force.to_s

Dir.chdir ARGV[0]
`ls -d */`.split("\n").each do |brandline|
	if brandline =~ /(新建|kankan|Recy)/
		next
	end
	brand = brandline.chop
	puts ">> Brand: " << brand
	brand_id = flag_force ? add_brand(brand) : 0
	`ls -d #{brandline}*/`.split("\n").each do |modeline|
		s = modeline.scan(/\/(.*)\//)
		if s && s.length > 0
			model = s[0]
			print "[#{model}], "
			add_model(brand_id,model) if flag_force
		end
	end
	puts ""
end


