require 'spec_helper'

describe 'request::params' do 

	it 'should get successfully' do
		get('/simple_get')
		expect(last_response).to be_ok
		expect(last_response.body).to eql('simple get')
	end

	it 'should post successfully' do
		post('simple_post')
		expect(last_response).to be_ok
		expect(last_response.body).to eql('simple post')
	end
	
	it 'should put successfully' do
		put('simple_put')
		expect(last_response).to be_ok
		expect(last_response.body).to eql('simple put')
	end

	it 'should delete successfully' do
		delete('/simple_delete')
		expect(last_response).to be_ok
		expect(last_response.body).to eql('simple delete')
	end

	def app
		MockServer
	end

end
