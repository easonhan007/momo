require 'spec_helper'

describe 'request::header' do 

	it 'should return correct header' do
		get('/header')
		expect(last_response).to be_ok
		expect(last_response.body).to eql('header')
		expect(last_response.headers['content-type']).to eql('application/json')
	end

	def app
		MockServer
	end

end
