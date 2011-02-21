# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "eventmachine"
require "pipe-run"

##
# Pipe class of the +pipe-run+. Currently with one static method only.
#

class Pipe
    
    ##
    # EventMachine connection to pipe.
    # @since 0.2.0
    # 
    
    
    class Receiver < EM::Connection
    
        ##
        # Holds pipe output buffer.
        #
        
        @buffer
        
        ##
        # Holds callback for giving back the results.
        #
        
        @callback
        
        ##
        # Constructor.
        # @param [Proc] callback callback for giving back the results
        #
        
        def initialize(callback = nil)
            @callback = callback
            @buffer = ""
        end
        
        ##
        # Receives data from pipe.
        # @param [String] data output from pipe
        #
        
        def receive_data(data)
            @buffer << data
        end
        
        ##
        # Action after terminating the connection. Calls callback.
        #
        
        def unbind
            if not @callback.nil?
                @callback.call(@buffer)
            end
        end
    end
    
    ##
    # Runs the command and returns its standard output.
    # Blocking.
    #
    # @param [String] command command for run
    # @param [Proc] block callback for giving back the results
    # @since 0.2.0
    #

    def self.run_nonblock(command, &block)
        pipe = File.popen(command, "r")
        EM::attach(pipe, Receiver, block)
    end
    
end
