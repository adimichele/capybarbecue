module Capybarbecue
  class AsyncDelegateClass
    attr_reader :instance

    def initialize(instance, &wait_proc)
      @instance = instance
      @wait_proc = wait_proc # Called repeatedly while waiting
    end

    def method_missing(method, *args, &block)
      call = AsyncCall.new(@instance, method, *args, &block)
      wrap_response(call.wait_for_response(&@wait_proc))
    end

    private

    def respond_to_missing?(method, include_all=false)
      @instance.respond_to?(method, include_all)
    end

    # Wrap anything that looks like Capybara
    def wrap_response(value)
      if value.class.name.include?('Capybara')
        AsyncDelegateClass.new(value, &@wait_proc)
      else
        value
      end
    end
  end
end