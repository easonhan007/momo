require 'json'
module Momo
	class Loader
		def initialize(config_file_path=nil)
			##@file_path = config_file_path || './config.json' 
			@file_path = './config.json' 
		end #initialzie

		def parse
			File.open(@file_path, 'r') do |f|
				JSON.load(f)
			end #open
		end

	end
end#Momo

