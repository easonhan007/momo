require 'spec_helper'

describe 'request::params' do 

	it 'should access /params with params and null value' do
		get('/params',{'blah' => nil})
		expect(last_response).to be_ok
		expect(last_response.body).to eql('bar')
	end

	it 'should not get response text when access /params without params' do
		get('/params')
		expect(last_response).to be_ok
		expect(last_response.body).not_to eql('bar')
		expect(last_response.body).to be_empty
	end

	it 'should access /multi_params with muli params' do
		get('/multi_params',{'foo' => nil, 'bar' => nil})
		expect(last_response).to be_ok
		expect(last_response.body).to eql('foo.bar')
	end
	
	it 'should access /params_with_value with params and value' do
		get('/params_with_value',{'key' => 'value'})
		expect(last_response).to be_ok
		expect(last_response.body).to eql('bar')
	end

	it 'should access /multi_params_with_value with params and value' do
		get('/multi_params_with_value',{'key' => 'value', 'another' => 'value'})
		expect(last_response).to be_ok
		expect(last_response.body).to eql('bar')
	end

	def app
		MockServer
	end

end
