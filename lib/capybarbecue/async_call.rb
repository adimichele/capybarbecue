require 'thread'

class AsyncCall # Asynchronously calls a method
  DEFAULT_TIMEOUT = 0.5
  attr_reader :thread
  attr_reader :ready
  alias :ready? :ready

  def initialize(obj, method, *args, &block)
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

  def wait_for_response(timeout=DEFAULT_TIMEOUT)
    started_at = Time.now
    while Time.now - started_at < timeout.seconds && !ready?
      sleep 0.05
    end
    kill! and raise Timeout::Error.new('Timeout expired before response received') unless ready?
    raise @exception if @exception.present?
    @response
  end

  def kill!
    @thread.kill
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