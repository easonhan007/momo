require 'spec_helper'
require 'pp'

describe Momo::Loader do 
	it 'should load another config file' do
		data = load_test_config('default_config')
		expect(data['request']['uri']).to eql('/foo')
		expect(data['response']['text']).to eql('bar')
	end

	it 'should load config.json by default' do
		data = Momo::Loader.new().parse
		expect(data[0]['request']['uri']).to eql('/foo')
		expect(data[0]['response']['text']).to eql('bar')
	end

	it 'should load config with multi config items' do
		data = load_test_config('multi')
		expect(data[0]['request']['uri']).to eql('/foo')
		expect(data[0]['response']['text']).to eql('bar')
		expect(data[1]['request']['uri']).to eql('/foo/bar')
		expect(data[1]['response']['text']).to eql('foo::bar')
	end

	def load_test_config(file_name)
		Momo::Loader.new("spec/test_config/#{file_name}.json").parse
	end
	
end