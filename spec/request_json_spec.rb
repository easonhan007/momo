require 'spec_helper'
require 'json'

describe 'request::json' do 

	it 'should post json string and get correct response' do
		post('/post_json_text', {'foo' => 'bar'}.to_json)
		expect(last_response).to be_ok
		expect(last_response.body).to eql('post json text')
	end

	it 'should not get correct response when post json text with wrong json string' do
		post('/post_json_text', {'key' => 'value'}.to_json)
		expect(last_response).to be_ok
		expect(last_response.body).not_to eql('post json text')
		expect(last_response.body).to be_empty
	end

	it 'should get correct response when post correct json file' do
	end

	it 'should get a 404 halt when post json file does not exist' do
	end

	def app
		MockServer
	end

end
