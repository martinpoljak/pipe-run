# encoding: utf-8
# (c) 2010 - 2011 Martin Kozák (martinkozak@martinkozak.net)

##
# Pipe class of the +pipe-run+. Currently with one static method only.
#

class Pipe

    ##
    # Runs the command and returns its standard output.
    # Blocking.
    #
    # @param [String] command command for run
    # @return [String] command output
    #

    def self.run(command)
        pipe = File.popen(command, "r")
        
        result = pipe.read
        pipe.close()
        
        return result
    end
    
end
