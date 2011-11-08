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
        # @returns [String] buffer content
        # @since 0.3.0
        #
        
        attr_accessor :buffer
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
    # Runs the command and yields its standard output.
    #
    # @param [String] command command for run
    # @param [Proc] block callback for giving back the results
    # @yield [String] command standard output
    # @since 0.2.0
    #

    def self.run_nonblock(command, &block)
        pipe = File.popen(command, "r")
        EM::attach(pipe, Receiver, block)
    end

    ##
    # Runs the command and yields both its standard output
    # and error output.
    #
    # @param [String] command command for run
    # @param [Proc] block callback for giving back the results
    # @yield [String] command standard output
    # @yield [String] command erroroutput
    # @since 0.3.0
    #

    def self.run_nonblock2(command, &block)
        begin
            stdin, stdout, stderr = Open3.popen3(command)
        rescue NameError
            require "open3"
            retry
        end
        
        outval = nil
        errval = nil
        
        yielder = Proc::new do
            if (not outval.nil?) and (not errval.nil?)
                yield outval, errval
            end 
        end
                
        outcall = Proc::new do |_outval|
             outval = _outval
             yielder.call()
        end
        
        errcall = Proc::new do |_errval|
             errval = _errval
             yielder.call()
        end
        
        EM::attach(stdout, Receiver, outcall)
        EM::attach(stderr, Receiver, errcall)
    end

end
