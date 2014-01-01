require 'spec_helper'

describe 'request::uri' do 

	it 'should access /foo' do
		get '/foo'
		expect(last_response).to be_ok
		expect(last_response.status).to eql 200
		expect(last_response.body).to eql('bar')
	end

	it 'should access /foo/bar' do
		get '/foo/bar'
		expect(last_response).to be_ok
		expect(last_response.body).to eql('foo.bar')
	end
	
	it 'should access /foo/bar/whatever' do
		get '/foo/bar/whatever'
		expect(last_response).to be_ok
		expect(last_response.body).to eql('foo.bar.whatever')
	end

	def app
		MockServer
	end

end