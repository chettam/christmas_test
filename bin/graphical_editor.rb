#!/usr/bin/env ruby

require './lib/editor'

editor = Editor.new
loop do
  command = STDIN.gets.chomp
  puts editor.execute(command)
end