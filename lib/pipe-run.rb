# encoding: utf-8
# (c) 2010 - 2011 Martin Kozák (martinkozak@martinkozak.net)

##
# Pipe class of the +pipe-run+. Currently with one static method only.
#

class Pipe

    ##
    # Runs the command and returns its standard output.
    #
    # If block is given, treat call as non-blocking. In that case, 
    # loads +em-pipe-run+ and expects EventMachine loaded.
    #
    # @param [String] command command for run
    # @param [Proc] block block for giving back the results
    # @yield [String] command output
    # @return [String] command output
    #

    def self.run(command, &block)
        if not block.nil?
            begin
                return self.run_nonblock(command, &block)
            rescue NoMethodError
                require "em-pipe-run"
                retry
            end
        end
        
        ###
        
        pipe = File.popen(command, "r")
        
        result = pipe.read
        pipe.close()
        
        return result
    end
    
    ##
    # Runs the command and returns both standard output 
    # and error output.
    #
    # If block is given, treat call as non-blocking. In that case, 
    # loads +em-pipe-run+ and expects EventMachine loaded.
    #
    # @param [String] command command for run
    # @param [Proc] block block for giving back the results
    # @return [Array] command output and error output
    # @since 0.3.0
    #

    def self.run2(command, &block)
        if not block.nil?
            begin
                return self.run_nonblock2(command, &block)
            rescue NoMethodError
                require "em-pipe-run"
                retry
            end
        end
        
        ###
        
        begin
            stdin, stdout, stderr = Open3.popen3(command)
        rescue NameError
            require "open3"
            retry
        end
        
        stdin.close()
        outvalue = stdout.read
        stdout.close()
        errvalue = stderr.read
        stderr.close()
        
        return [outvalue, errvalue]
    end
    
end
