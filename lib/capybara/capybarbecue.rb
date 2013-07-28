# Include files, register driver, etc
require 'capybara'

module Capybara
  module Capybarbecue

  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Capybarbecue::Driver.new(app)
end