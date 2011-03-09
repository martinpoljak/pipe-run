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
    # +em-pipe-run+ file must be loaded.
    #
    # @param [String] command command for run
    # @param [Proc] block block for giving back the results
    # @return [String] command output
    #

    def self.run(command, &block)
        if not block.nil?
            if not self.respond_to? :run_nonblock
                require "em-pipe-run"
            end
            
            return self.run_nonblock(command, &block)
        end
        
        ###
        
        pipe = File.popen(command, "r")
        
        result = pipe.read
        pipe.close()
        
        return result
    end
    
end
