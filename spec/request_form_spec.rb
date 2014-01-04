require 'spec_helper'

describe 'request::form' do 

	it 'should access /from with form params when post' do
		post('/form',{'foo' => 'bar'})
		expect(last_response).to be_ok
		expect(last_response.body).to eql('form')
	end

	it 'should not get correct result when post /from without form params' do
		post('/form')
		expect(last_response).to be_ok
		expect(last_response.body).not_to eql('form')
		expect(last_response.body).to eql('')
	end

	it 'should work well when post with form and ? params' do
		post('/form_with_params', {'key' => 'value', 'foo' => 'bar'})
		expect(last_response).to be_ok
		expect(last_response.body).to eql('form')
	end

	def app
		MockServer
	end

end
