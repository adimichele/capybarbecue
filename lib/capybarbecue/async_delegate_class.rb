module Capybarbecue
  class AsyncDelegateClass
    attr_reader :instance

    def initialize(instance, &wait_proc)
      @instance = instance
      @wait_proc = wait_proc # Called while waiting
    end

    def method_missing(method, *args, &block)
      call = AsyncCall.new(@instance, method, *args, &block)
      @wait_proc.call if @wait_proc
      wrap_response(call.wait_for_response)
    end

    private

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