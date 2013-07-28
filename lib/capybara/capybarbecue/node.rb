module Capybara::Capybarbecue
  class Node < Capybara::Driver::Node
    # Ferries Node method calls over to the WebDriver thread
    # Wraps any Node return values in a Capybara::Capybarbecue::Node
  end
end