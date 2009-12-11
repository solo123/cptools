#! /usr/bin/ruby
#
require "rubygems"
require "coolpur_tools"

def	test(arg)
	puts arg
end

if ARGV.length == 0
	puts <<USAGE
Usage: #{$0} [functions]
  -mn		Update Mobile names.
  -qt		Update Mobile Quotations.

USAGE
	exit 0
end

ARGV.each do |arg|
	case arg
	when "-mn"
		CoolpurTools.new.update_mobile_name
	when "-qt"
		CoolpurTools.new.update_mobile_quotation
	else
		puts "illegle arg: #{arg}"
	end
end
