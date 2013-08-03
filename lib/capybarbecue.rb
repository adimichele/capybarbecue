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
      #require 'capybara/server'

      (class << Capybara; self end).instance_eval do
        alias_method :original_session, :current_session
        define_method :current_session do
          Capybarbecue::AsyncDelegateClass.new(original_session)
        end
      end
    end

    def deactivate!
      # Make sure this kills all threads too?
      (class << Capybara; self end).instance_eval do
        alias_method :current_session, :original_session
        remove_method :original_session
      end
    end
  end
end