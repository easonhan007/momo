class MockServer < Sinatra::Base
	# add your custom code here
	# get '/' do
			# return 'foo.bar' if params['foo'] == 'bar'
			# return 'hello.world' if params['hello'] == 'world'
	# end
	run! if app_file == $0
end
