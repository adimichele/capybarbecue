# Re-implementation of Capybara::Server

class Capybara::Server
  # Takes a Rack request and ferries it over to RackRunner
  # Booted from Capybara::Session#initialize which isn't called until somebody actually asks for Capybara.current_session
  # so it should be safe to just re-implement this class
end