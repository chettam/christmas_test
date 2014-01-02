class Editor


	COMMANDS = {
    :LIST => 'Shows this command list',
    :I => 'Create a new M x N image with all pixels coloured white (O)',
    :C => 'Clears the table, setting all pixels to white (O)',
    :L => 'Colours the pixel (X,Y) with colour C.',
    :V => 'Draws a vertical segment of colour C in column X between rows Y1 and Y2 inclusive',
    :H => 'Draws a horizonal segment of colour C in row Y between columns X1 and X2 inclusive',
    :F => 'Fills contiguous pixels with colour C starting at pixel X,Y',
    :S => 'Shows the current image',
    :E => 'Exit'
  }

	def initialize
		header
		@image = nil
	end

	def header
		puts "Graphical Editor. Available Commands"
		# list
	end


	def list 
		COMMANDS.each{|shortcut,desc| puts "\t#{shortcut} => #{desc}"}
	end
end