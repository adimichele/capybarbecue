require 'thread'

class AsyncCall # Asynchronously calls a method
  DEFAULT_TIMEOUT = 5.0
  attr_reader :thread
  attr_reader :ready
  attr_reader :to_s
  alias :ready? :ready

  def initialize(obj, method, *args, &block)
    @obj, @method, @args, @block = obj, method, args, block
    @ready = false
    @response = nil
    @exception = nil
    @thread = Thread.new do
      begin
        respond_with obj.send(method, *args, &block)
      rescue Exception => e
        respond_with_exception e
      end
    end
  end

  # If a block is passed, it will be called repeatedly until a response comes in
  def wait_for_response(timeout=DEFAULT_TIMEOUT)
    started_at = Time.now
    while Time.now - started_at < timeout.seconds && !ready?
      yield if block_given?
      # It feels dangerous not to sleep here... keep a pulse on this (sleep causes performance problems)
      Thread.pass
    end
    kill! and raise Timeout::Error.new('Timeout expired before response received') unless ready?
    if @exception.present?
      # Add the backtrace from this thread to make it useful
      backtrace = @exception.backtrace + Kernel.caller
      @exception.set_backtrace(backtrace)
      raise @exception
    end
    @response
  end

  def kill!
    @thread.kill
  end

  def to_s
    s = "#{@obj.class.name}##{@method}(#{@args.map{ |a| a.class.name }.join(', ')})"
    s += ' { ... }' if @block.present?
    s
  end

  private

  def respond_with(value)
    @response = value
    @ready = true
  end

  def respond_with_exception(e)
    @exception = e
    @ready = true
  end
end