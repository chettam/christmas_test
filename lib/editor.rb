require_relative 'image'
class Editor

	COLORS = ('A'..'Z').to_a
	MAX_SIZE = 250


	COMMANDS = {
    LIST: 'Shows this command list',
    I: 'Create a new M x N image with all pixels coloured white (O)',
    C: 'Clears the table, setting all pixels to white (O)',
    L: 'Colours the pixel (X,Y) with colour C.',
    V: 'Draws a vertical segment of colour C in column X between rows Y1 and Y2 inclusive',
    H: 'Draws a horizonal segment of colour C in row Y between columns X1 and X2 inclusive',
    F: 'Fills contiguous pixels with colour C starting at pixel X,Y',
    S: 'Shows the current image',
    E: 'Exit'
  }

	def initialize
		header
		@image = nil
	end

	def header
		puts "Graphical Editor. Available Commands"
		list
	end

	def list 
		COMMANDS.each{|shortcut,desc| puts "\t#{shortcut} => #{desc}"}
	end

	def execute(input)
		return "Please enter a valid command" if input.empty? || input =='\t' || input =='\t\r'
		command = parse(input)
		 valid_command?(command)
	end

	def parse(input)
		args = input.split(' ').map do |x| 
			Integer(x) rescue x 
		end
	end

	def valid_command?(args)
		return 'Invalid command, please enter a valid command' unless COMMANDS.has_key?(args[0].to_sym)
		cmd = args.shift
		params = args.length > 0 ? args : nil 

		case cmd
			when "I"
				command_i(params)
			when 'C'
				command_c 
			when 'L'
				command_l(params)
			when 'V'
				command_v(params)
			when 'H'
				command_h(params)
			when 'F'
				command_f(params)
			when 'S'
				command_s
			when 'E'
				command_e
			when 'LIST'
				list
			end
	end

	def valid_color?(color)
		raise ArgumentError, 'Invalid color' unless COLORS.include?(color)
		color
	end

	def valid_coords?(coords)
		raise ArgumentError, 'Invalid coordinates' unless coords.length == 2 && @image.contain?(coords)
		coords
	end

	def valid_number_of_params(params,number)
		params.length == number
	end

	def command_i(params)
		return "Invalid image size, please create an image of less than 250 x 250 px" if params.any?{|param| param >  MAX_SIZE}
		return "Invalid number of params" unless valid_number_of_params(params,2)
		return "Image already created, use c to clear" unless @image.nil?
		@image = Image.new(params[0],params[1])
	end

	def command_c
		return "no image to clear" if @image.nil?
		@image = Image.new(@image.m,@image.n)
	end

	def command_l(params)
		return "no image" if @image.nil?
		return "Invalid number of params" unless valid_number_of_params(params,3)
		coords = valid_coords?(params.shift(2))
		color = valid_color?(params.first)
		@image.color_pixel!(coords,color)
	end
	
	def command_v(params)
		return "no image" if @image.nil?
		return "Invalid number of params" unless valid_number_of_params(params,4)
	end

	def command_h(params)
		return "no image" if @image.nil?
		return "Invalid number of params" unless valid_number_of_params(params,4)
	end

	def command_f(params)
		return "no image" if @image.nil?
		return "Invalid number of params" unless valid_number_of_params(params,3)
	end

	def command_s
		return 'No Image, please create an image first' if @image.nil?
		puts @image
	end

	def command_e
		puts 'Thanks for using Graphical editor'
		exit
	end
end