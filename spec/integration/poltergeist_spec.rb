require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe 'With a real life app', :type => :feature do
  # Test methods specific to Poltergeist to make sure they're passed through correctly
  before do
    Capybara.current_driver = :poltergeist
  end
  describe Capybara::Poltergeist::Driver do
    pending 'Test specific interfaces for compatibility'
  end
  describe Capybara::Poltergeist::Node do
    pending 'Test specific interfaces for compatibility'
  end
end