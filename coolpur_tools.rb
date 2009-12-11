require 'rubygems'
require "db_model"

class CoolpurTools
  def update_mobile_quotation
    puts ">> Update quotations"
	puts "   -----------------"   
	quotations = Quotation.all(:conditions => "status=2", :order => "mobile_id,quotation_date desc")
	tot = quotations.length
	i = 0
	j = 0
	m = 0
    quotations.each do |quotation|
	  i += 1
	  str = ""
      if (m!=quotation.mobile_id)
        m = quotation.mobile_id
        mq = Mquotation.find_by_mobile_id(m)
        if !mq || mq.price != quotation.quotation_price
          if mq
            mq.price = quotation.quotation_price
            mq.date = quotation.quotation_date
          else
            mq = Mquotation.new
            mq.mobile_id = m
            mq.price = quotation.quotation_price
            mq.date = quotation.quotation_date
          end
          mq.save!

          mobile = Mobile.find(m)
          if mobile && mobile.price <= mq.price
            str <<  " #{mobile.model} Mobile</b> price #{mobile.price} update to #{mq.price}"
            mobile.price = mq.price + 100
            mobile.save
          end
          str << ">> ID:#{m}, Price:#{quotation.quotation_price}"
        end
      end
	  print "Total[#{tot}] Current#{i}[] Update[#{j}] " << str << "\r"
      quotation.status = 3
      quotation.save!
    end
	puts "\n  DONE-----------"
  end
  
  def update_mobile_name
    puts ">> Update mobiles name"
	puts "   -------------------"
    mobiles = Mobile.all(:conditions => "brand_id>0")
	tot = mobiles.length
	i = 0
	j = 0
	n = ""
    mobiles.each do |mobile|
	  i += 1
	  str = ""
      if b = Brand.find_by_id(mobile.brand_id)
        n = b.brand_name << ' ' << mobile.model
        if n != mobile.name
	  	  j += 1
          mobile.name = n
          mobile.save!
		  str = n
        end
      end
      print "  Total:[#{tot}] Skip:[#{i}] Update[#{j}] " << str << " \r"
    end
    puts "\n  Done.-------------"
  end
  
end
