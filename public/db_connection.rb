require 'rubygems'
require 'yaml'
require 'active_record'

class CoolpurDB < ActiveRecord::Base
  self.abstract_class = true
  config = YAML.load_file("../config/database.yml")["development"]
  establish_connection( 
   :adapter  => config["adapter"],
   :database => config["database"],
   :encoding => config["encoding"],
   :username => config["username"],
   :password => config["password"],
   :host     => config["host"]
  )
end


