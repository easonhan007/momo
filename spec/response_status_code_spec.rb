require 'spec_helper'

describe 'response::status_code' do 

	it 'should return correct status code' do
		get '/status_300'
		expect(last_response.body).to eql('status 300')
		expect(last_response.status).to eql(300)
	end

	def app
		MockServer
	end

end
