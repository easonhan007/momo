require 'spec_helper'

describe 'response::content' do 

	it 'should return json string' do
		get '/return_json'
		expect(last_response).to be_ok
		expect(last_response.header['content-type']).to include('application/json')
		expect(JSON.load last_response.body).to eql({'foo' => 'bar'})
	end

	it 'should return xml string' do
		get '/return_xml'
		expect(last_response).to be_ok
		expect(last_response.header['content-type']).to include('text/xml')
		expect(last_response.body).to eql('<name>momo</name><type>mock server</type>')
	end

	def app
		MockServer
	end

end
