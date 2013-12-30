require 'sinatra/base'
require './loader'

module Momo
	class OptionParser
		def initialize data
			@options = {}
			@options['response'] = {}
			raise 'json config file error' if data.nil?
			@data = data
		end		

		def do
			@options['uri']  = uri
			@options['method']  = method
			@options['params']  = params
			@options['response']['headers']  = response_header
			@options['response']['content'] = response_content
			@options['response']['status'] = response_status
			@options['redirect'] = redirect
			@options
		end

		def redirect
			@data['redirectTo'] || ''
		end

		def response_content
			content = {}
			if @data['response']['text']
				content['type'] = 'text'
				content['value'] = @data['response']['text']
			end #if

			if @data['response']['file']
				content['type'] = 'file'
				content['value'] = @data['response']['file']
			end #if

			content
		end

		def response_status
			@data['response']['status'] || 200
		end

		def uri
			@data['request']['uri'] || '/'
		end #uri

		def method
			@data['request']['method'].to_sym || :get
		end

		def params
			@data['request']['params'] || ''
		end

		def response_header
			@data['request']['headers'] || nil
		end

	end #OptionParser
end #Momo

class MockServer < Sinatra::Base
	data = Momo::Loader.new.parse
	op = Momo::OptionParser.new(data).do

	send(op['method'], op['uri'])  do
		redirect(op['redirect']) and return if op['redirect']
		
		direct_return = true
		if(op['params'])
			direct_return = false if op['params'] != params
		end #if	

		if op['method'] == :post and op['form']
			direct_return = false if op['form'] != params
		end

		status op['response']['status']
		headers op['response']['headers'] if op['response']['headers']

		if op['response']['content']['type'] == 'text' and direct_return
			return op['response']['content']['value']
		end #if

		if op['response']['content']['type'] == 'file' and direct_return
			return erb(op['response']['content']['value'])
		end #if

	end
	
	run! if app_file == $0
end
