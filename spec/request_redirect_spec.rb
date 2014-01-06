require 'spec_helper'

describe 'request::redirect' do 

	it 'should redirect correctly' do
		#get('/redirect')
		#expect(last_response).to be_ok
		#expect(last_response.url).to eql('http://www.github.com')
	end

	def app
		MockServer
	end

end
