module Capybarbecue
  class RackRunner
    # Rack runner portion of main thread
    # Reads rack requests of a message queue, runs them, and puts the result on another MQ
    # Should have some sort of delay or signaling system to eliminate race conditions when waiting for requests
  end
end