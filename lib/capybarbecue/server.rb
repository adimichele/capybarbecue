require 'thread'

module Capybarbecue
  class Server
    DEFAULT_TIMEOUT = 30
    attr_accessor :wait_for_response # For testing - set to false to keep #call from blocking
    attr_accessor :timeout, :app

    def initialize(app)
      @app = app
      @requestmq = Queue.new
      @wait_for_response = true
      @timeout = DEFAULT_TIMEOUT
    end

    def call(env)
      queue_and_wait(env)
    end

    # Should be run by another thread - respond to all queued requests
    def handle_requests
      until @requestmq.empty?
        request = @requestmq.deq(true)
        begin
          request.response = @app.call(request.env)
        rescue Exception => e
          request.exception = e
        end
      end
    end

    private

    def queue_and_wait(env)
      request = QueuedRequest.new(env)
      @requestmq.enq(request)
      return unless wait_for_response
      started_at = Time.now
      while !request.ready? && Time.now - started_at < timeout.seconds
        # It feels dangerous not to sleep here... keep a pulse on this (sleep causes performance problems)
        Thread.pass
      end
      raise Timeout::Error.new('Timeout expired before response received') unless request.ready?
      if request.exception.present?
        # Add the backtrace from this thread to make it useful
        backtrace = request.exception.backtrace + Kernel.caller
        request.exception.set_backtrace(backtrace)
        raise request.exception
      end
      request.response
    end

    class QueuedRequest
      attr_reader :env
      attr_accessor :response, :exception
      def initialize(env)
        @env = env
      end
      def ready?
        @response.present? || @exception.present?
      end
    end
  end
end