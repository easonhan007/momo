require 'spec_helper'

describe 'request::matcher' do 

	it 'should define uri using regexp' do
		(0..9).each do |i|
			get("/regexp#{i}")
			expect(last_response).to be_ok
			expect(last_response.body).to eql(i.to_s)

			get '/regexp'
			expect(last_response).not_to be_ok
		end #each
	end

	def app
		MockServer
	end

end
