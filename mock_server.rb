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

		def parse
			@options['uri']  = uri
			@options['method']  = method
			@options['params']  = params
			@options['form']  = form
			@options['response']['headers']  = response_header
			@options['response']['content'] = response_content
			@options['response']['status'] = response_status
			@options['redirect'] = redirect
			@options['cookies'] = cookies
			@options['latency'] = latency
			@options['condition'] = condition

			@options
		end

		def condition
			@data['request']['condition']  || {}
		end

		def latency
			@data['response']['latency']
		end

		def form
			@data['request']['forms'] 
		end

		def cookies
			@data['response']['cookies'] || @data['request']['cookies'] || nil
		end

		def redirect
			@data['redirectTo']
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
			@data['request']['method'].to_sym rescue :get
		end

		def params
			@data['request']['queries']['params'] rescue nil
		end

		def response_header
			@data['request']['headers']
		end

	end #OptionParser
end #Momo

class MockServer < Sinatra::Base
	enable :logging

	data = Momo::Loader.new.parse
	data = [data] unless data.is_a?(Array) 

	data.each do |d|
		op = Momo::OptionParser.new(d).parse
		send(op['method'], op['uri'], op['condition'])  do
			direct_return = true
			redirect(op['redirect']) and return if op['redirect']
			
			if(op['method'] == :get and op['params'])
				params_hash= params.to_hash
				direct_return = false if op['params'] != params_hash
			end #if	

			if [:post, :put].include?(op['method']) and op['form']
				if(op['params'] and op['params'].is_a?(Hash))
					# direct_return = false unless (params - op['params']) == op['form']
					get_params = {}
					op['params'].each do |k, v|
						get_params[k] = params.delete(k)
					end #each
					direct_return = false unless get_params == op['params'] && op['form'] == params
				else
					direct_return = false unless op['form'] == params
				end #if
			end

			status op['response']['status']
			headers op['response']['headers'] if op['response']['headers']
			if op['cookies'] && op['cookies'].is_a?(Hash)	
				op['cookies'].each do |k, v|
					response.set_cookie(k, value: v, domain: '', path: '/')
				end #each
			end #if

			output = case op['response']['content']['type'] 
			when 'text'
				op['response']['content']['value']
			when 'file'
				erb(op['response']['content']['value'])
			when 'json'
				content_type :json	
				op['response']['content']['value']
			when 'xml'
				content_type 'text/xml'
				op['response']['content']['value']
			end #case

			sleep(op['latency'].to_i) if op['latency']

			return output if direct_return	

		end #send
	end #each
	
	require './user_define'

	run! if app_file == $0
end
