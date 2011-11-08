Pipe Run
========

**Pipe Run** runs command and returns its standard output in one call:

    require "pipe-run"
    
    stdout = Pipe.run("date")       # blocking
    puts stdout         # will print out for example 'Thu Feb 17 17:22:18 CET 2011'
    
    stdout, errout = Pipe.run2("date")       # blocking
    puts stdout         # will print out for example 'Thu Feb 17 17:22:18 CET 2011'

    
### Asynchronous Use

In case, [`eventmachine`][1] is available, non-blocking run of the command is 
possible using `#run_nonblock` or `#run` with block given, defined in 
`em-pipe-run` file. So for example:

    EM::run do
        Pipe.run("date") do |stdout|    # non-blocking
            puts stdout     # will print out for example 'Thu Feb 17 17:22:18 CET 2011'
        end
        
        Pipe.run2("date") do |stdout, errout|    # non-blocking
            puts stdout     # will print out for example 'Thu Feb 17 17:22:18 CET 2011'
        end
    end
    
Contributing
------------

1. Fork it.
2. Create a branch (`git checkout -b 20101220-my-change`).
3. Commit your changes (`git commit -am "Added something"`).
4. Push to the branch (`git push origin 20101220-my-change`).
5. Create an [Issue][2] with a link to your branch.
6. Enjoy a refreshing Diet Coke and wait.

Copyright
---------

Copyright &copy; 2010 &ndash; 2011 [Martin Kozák][3]. See `LICENSE.txt` for
further details.

[1]: http://rubyeventmachine.com/
[2]: http://github.com/martinkozak/pipe-run/issues
[3]: http://www.martinkozak.net/
