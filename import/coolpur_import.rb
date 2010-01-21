require "db_model"

class CoolpurImport
	def show_data
		imp_mobiles = Imp_mobile.all
		imp_mobiles.each do |im|
			puts "ÖÐÎÄ>" << im.brand << ' - ' << im.model << '(' << im.remark << ')'
		end
		
		puts " ================= "
		
		mobiles = Mobile.all
		mobiles.each do |m|
			puts m.brand_id.to_s << ' - ' << m.model << '(' << m.remark << ')'
		end
	end
  
  def update_mobile_info
		puts "\n ------Start to update---------"
		imps = Imp_mobile.all(:conditions => 'brand_id>0 and status=0')
		i,j = 1,1
		imps.each do |imp|
      if m = Mobile.find(:first, :conditions => ["brand_id=? and model=?", imp.brand_id, imp.model])
        m.part = imp.part
        m.remark = imp.remark
        m.price = imp.price ? imp.price : 0
        m.save!
        puts " ==> #{i.to_s}updated mobile!" << imp.brand_id.to_s << "-" << imp.model << " = " << imp.price.to_s
        i += 1
      else
        m = Mobile.new(
          :brand_id => imp.brand_id,
          :model => imp.model,
          :part => imp.part,
          :price => imp.price ? imp.price : 0,
          :remark => imp.remark
        )
        m.save!
        j += 1
        puts " ==> #{j.to_s}Added mobile!" << imp.brand_id.to_s << "-" << imp.model << " = " << imp.price.to_s
      end
      imp.status = 1
      imp.save!
    end
		puts "\n ======End of import======"
  end
	
	def import_mobile
		puts "\n ------Start to import---------"
		imps = Imp_mobile.all(:conditions => 'brand_id>0 and status=0')
		j = 1
		imps.each do |imp|
      if m = Mobile.find(:first, :conditions => ["brand_id=? and model=?", imp.brand_id, imp.model])
        puts " ==> Skipped..."
      else
        m = Mobile.new(
          :brand_id => imp.brand_id,
          :model => imp.model,
          :part => imp.part,
          :price => imp.price ? imp.price : 0,
          :remark => imp.remark
        )
        m.save!
        j += 1
        puts " ==> #{j.to_s}Added mobile!" << imp.brand_id.to_s << "-" << imp.model << " = " << imp.price.to_s
      end
      imp.status = 1
      imp.save!
    end
		puts "\n ======End of import======"
	end
  
  def import_brand
    puts "\n------import new brands-------"
    imps = Imp_mobile.all(:conditions => "brand_id is null or brand_id=0")
    imps.each do |imp|
      if b = Brand.find(:first, :conditions => ["short_name=? or brand_name=?", imp.brand,imp.brand])
        imp.brand_id = b.id
        imp.save!
        puts " ==> skipped: " << b.id.to_s << ":" << b.brand_name
      else
        b = Brand.new(:short_name => imp.brand, :brand_name => imp.brand, :status => 0)
        b.save!
        imp.brand_id = b.id
        imp.save!
        puts " ==> Added: " << b.id.to_s << ":" << b.brand_name
      end
    end
    puts "\n======end of import new brands======="
  end
  
  def import_quotation(qdate)
    puts "\n------import quotations-------"
    imps = Imp_quotation.all(:conditions => "status=0")
    imps.each do |imp|
      q = Quotation.new(
        :brand_short_name => imp.brand,
        :model_short_name => imp.model,
        :quotation_price => imp.price,
        :remark => imp.remark,
        :quotation_date => qdate
      )
      q.save!
      imp.status = 1
      imp.save!
      puts " ==> Added: " << q.id.to_s << ":" << q.brand_short_name << '-' << q.model_short_name
    end
    puts "\n======end of import quotations======="
  end
	
	
end
