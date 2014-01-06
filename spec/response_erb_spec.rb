require 'spec_helper'

describe 'response::erb' do 

	it 'should render erb file' do
		get '/erb'
		expect(last_response).to be_ok
		expect(last_response.body.strip).to eql('Hello erb')
	end

	def app
		MockServer
	end

end
