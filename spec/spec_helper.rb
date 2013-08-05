#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybarbecue'
require 'rr'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Capybara.default_driver = :poltergeist
Capybara.app = TestRackApp.new
Capybarbecue.activate!

RSpec.configure do |config|
  config.mock_with :rr
end
