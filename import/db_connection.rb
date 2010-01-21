require 'rubygems'
require 'active_record'

class CoolpurDB < ActiveRecord::Base
  self.abstract_class = true
  establish_connection( 
   :adapter  => "sqlite3",
   :database => "/home/jmmy/work/sales/db/development.sqlite3",
   :encoding => "gbk"
  )
end


