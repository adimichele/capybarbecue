require 'active_support/all'

module Capybarbecue
  class << self
    def activated?
      Capybara.respond_to? :original_session
    end

    def activate!
      return if activated?
      require 'capybarbecue/async_call'
      require 'capybarbecue/async_delegate_class'
      require 'capybarbecue/rack_runner'
      require 'capybarbecue/server'

      (class << Capybara; self end).instance_eval do
        alias_method :original_session, :current_session
        define_method :current_session do
          Capybarbecue::AsyncDelegateClass.new(original_session) do
            Capybara.app.handle_requests
          end
        end
      end

      Capybara.send(:session_pool).clear

      # Swap out Capybara's server for the one that waits
      # Do this by deleting everything in Capybara#session_pool (private) and swapping Capybara.app
      new_app = Capybarbecue::Server.new(Capybara.app)
      Capybara.app = new_app
    end

    def deactivate!
      # Make sure this kills all threads too?
      return unless activated?
      (class << Capybara; self end).instance_eval do
        alias_method :current_session, :original_session
        remove_method :original_session
      end
      Capybara.send(:session_pool).clear
      Capybara.app = Capybara.app.app
    end
  end
end