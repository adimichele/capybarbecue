module Capybara::Capybarbecue
  class Driver < Capybara::Driver::Base
    # Ferries driver method calls over to the WebDriver thread
    # Wraps any Node return values in a Capybara::Capybarbecue::Node
    def initialize(app)

    end
  end
end