class MockServer < Sinatra::Base
	# add your custom code here
	# get '/' do
			# return 'foo.bar' if params['foo'] == 'bar'
			# return 'hello.world' if params['hello'] == 'world'
	# end

	get '/user_define' do
		'Define custom url here'
	end

end
