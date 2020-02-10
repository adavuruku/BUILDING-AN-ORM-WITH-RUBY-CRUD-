#!/usr/bin/env ruby
require 'readline'
while line = Readline.readline('> ', true)
  f = line.split(" ")
  if f[0]=="exit" 
      p "Goodbye!"
      break
  end
  p f
end