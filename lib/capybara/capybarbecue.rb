# Include files, register driver, etc
require 'capybara'

module Capybara
  module Capybarbecue
    require 'capybara/capybarbecue/node'
    require 'capybara/capybarbecue/driver'
  end
end

Capybara.register_driver :capybarbecue do |app|
  Capybara::Capybarbecue::Driver.new(app)
end