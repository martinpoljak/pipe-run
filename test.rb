#!/usr/bin/ruby
# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

$:.push("./lib")
$:.unshift("./lib")

require "eventmachine"
require "pipe-run"
require "em-pipe-run"


EM::run do
    p Pipe::run("date")
    p Pipe::run2("date")
    
    Pipe::run("date") do |out|
        p out
    end
    
    Pipe::run2("date") do |*args|
        p args
    end
    
    p "x"
end
