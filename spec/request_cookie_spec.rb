require 'spec_helper'

describe 'request::cookies' do 

	it 'should set cookie' do
		get('/cookie')
		expect(last_response).to be_ok
		expect(last_response.body).to eql('cookie')
		# expect(last_request.cookies).to eql({ 'foo'=> 'bar' })
		# expect(last_response.cookies).to eql({ 'foo'=> 'bar' })
	end


	def app
		MockServer
	end

end
