require 'thread'

module Capybarbecue
  class AsyncExecuter
    attr_reader :thread

    def initialize
      @queue = Queue.new
      @thread = Thread.new do
        while true
          # This #run method should handle its own exceptions
          @queue.deq.run
        end
      end
    end

    def execute(async_call)
      if in_executer?
        async_call.run
      else
        @queue.enq(async_call)
      end
    end

    def kill!
      @thread.kill
    end

    private

    def in_executer?
      Thread.current == @thread
    end
  end
end