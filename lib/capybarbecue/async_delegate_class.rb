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

    # This is our hint that we are an AsyncDelegateClass
    def __async_delegate__
      true
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
  class AsyncDelegateClass
    ## For instance methods of Object, delegate these to the object we've wrapped
    super_methods = superclass.instance_methods - (instance_methods - superclass.instance_methods)
    super_methods -= [:methods, :__send__, :__id__, :respond_to?] # Don't override these bad boys
    super_methods.each do |method|
      define_method method do |*args, &block|
        method_missing(method, *args, &block)
      end
    end
  end
end