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
			@options['post_json_text'] = post_json_text
			@options['post_json_file'] = post_json_file

			@options
		end

		def post_json_text
			json_data = @data['request']['text']['json'] rescue nil
			make_request_method_to_post(json_data)
			json_data
		end

		def post_json_file
			json_data = @data['request']['file']['json'] rescue nil
			make_request_method_to_post(json_data)
			json_data
		end

		def make_request_method_to_post(json_data)
			@options['method'] = :post if (json_data and [:get, :delete].include?(@options['method']))
		end

		def condition
			@data['request']['condition']  || {}
		end

		def latency
			@data['response']['latency'] rescue nil
		end

		def form
			@data['request']['forms'] 
		end

		def cookies
			@data['response']['cookies']  rescue nil
		end

		def redirect
			@data['redirectTo']
		end

		def response_content
			if @data['response']
				content = {}
				if @data['response']['text']
					content['type'] = 'text'
					content['value'] = @data['response']['text']
				end #if

				if @data['response']['file']
					content['type'] = 'file'
					content['value'] = @data['response']['file']
				end #if

				if @data['response']['json']
					content['type'] = 'json'
					content['value'] = @data['response']['json']
				end #if
				
				if @data['response']['xml']
					content['type'] = 'xml'
					content['value'] = @data['response']['xml']
				end #if

				content
			end #if
		end

		def response_status
			@data['response']['status'] || 200 if @data['response']
		end

		def uri
			if @data['request']['uri'] and @data['request']['uri'].include?('%r')
				@data['request']['uri'] = eval(@data['request']['uri'])
			end #if
			@data['request']['uri'] || '/'
		end #uri

		def method
			@data['request']['method'].to_sym rescue :get
		end

		def params
			@data['request']['queries']['params'] rescue nil
		end

		def response_header
			@data['response']['headers'] rescue nil
		end

	end #OptionParser
end #Momo

class MockServer < Sinatra::Base
	enable :logging

	data = Momo::Loader.new.parse
	data = [data] unless data.is_a?(Array) 

	data.each do |d|
		op = Momo::OptionParser.new(d).parse
		if ENV['RACK_ENV'] == 'test'
			print op['method']
			puts " #{op['uri']}"
			puts op['uri'].class
		end #if
		send(op['method'], op['uri'], op['condition'])  do
			direct_return = true
			redirect(op['redirect']) if op['redirect']
			
			# handle get method with params
			if(op['method'] == :get and op['params'])
				params_hash= params.to_hash
				direct_return = false if op['params'] != params_hash
			end #if	

			# handle post or put method with form and params
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

			# handle post json
			if op['post_json_text']
				direct_return = false unless JSON.parse(op['post_json_text']) == JSON.parse(request.env["rack.input"].read)
			end #if

			if op['post_json_file']
				halt(404, "#{op['post_json_file']} does not exist") unless File.exist?(op['post_json_file'])
				unless Momo::Loader.new(op['post_json_file']).parse == JSON.parse(request.env["rack.input"].read)
					direct_return = false 
				end #unless
			end #if

			# handle response status
			status op['response']['status'] if op['response']['status']

			#handle cookies
			headers op['response']['headers'] if op['response']['headers']
			if op['cookies'] && op['cookies'].is_a?(Hash)	
				op['cookies'].each do |k, v|
					response.set_cookie(k, value: v, domain: '', path: '/')
				end #each
			end #if

			# handle output
			output = case op['response']['content']['type'] 
			when 'text'
				op['response']['content']['value']
			when 'file'
				erb(op['response']['content']['value'].to_sym)
			when 'json'
				content_type :json	
				op['response']['content']['value']
			when 'xml'
				content_type 'text/xml'
				op['response']['content']['value']
			end #case

			sleep(op['latency'].to_i) if op['latency']

			output = eval(output) if output and output.include?('params')
			return output if direct_return	

		end #send
	end #each
	
	require './user_define'

	run! if app_file == $0
end
