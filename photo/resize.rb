require 'rubygems'
require 'mini_magick'


Dir[ARGV[0] + '/**/*.{jpg,JPG}' ].each do |f|
	img = MiniMagick::Image.from_file f
	if img[:width] > 600
		img.resize 600
		img.write f
		puts f
	end
end
