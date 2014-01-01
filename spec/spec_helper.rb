ENV['RACK ENV'] = 'test'
$LOAD_PATH << File.realpath(File.join('.'));
$LOAD_PATH << File.realpath(File.join('.', 'spec'));
require 'rspec'
require 'rack/test'
require 'mock_server'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
