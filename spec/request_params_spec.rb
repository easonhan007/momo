require 'spec_helper'

describe 'request::params' do 

	it 'should access /params with params' do
		get('/params',{'blah'}, nil)
		expect(last_response).to be_ok
		# expect(last_response.body).to eql('bar')
	end

	def app
		MockServer
	end

end