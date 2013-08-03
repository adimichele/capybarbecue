require 'active_support/all'

module Capybarbecue
  class << self
    def activate!
      require 'capybarbecue/rack_runner'
      require 'capybarbecue/server'
      require 'capybarbecue/async_call'

      require 'capybara/capybarbecue'
      #require 'capybara/server'

      #Redefine current_session to use the Capybarbecue session regardless of what drivers are used in Capybara
      (class << Capybara; self end).instance_eval do
        alias_method :original_session, :current_session
        define_method :current_session do
          @bbq_session ||= Capybara::Session.new(:capybarbecue, app)
        end
      end
    end

    def deactivate!
      # Make sure this kills all threads too
      (class << Capybara; self end).instance_eval do
        alias_method :current_session, :original_session
      end
    end
  end

  # Capybara.current_session needs to return the Capybarbecue session
end