require 'yaml'

class Tt
	def test
	  config = YAML.load_file("../config/database.yml")["development"]
	  puts config["adapter"]
	end
end

Tt.new.test
