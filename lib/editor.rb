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

	def list(*params)
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
		cmd = args.shift.downcase
		params = args.length > 0 ? args : nil 
		begin 
			self.send(cmd,params)
		rescue StandardError => standard_error
			puts  standard_error.message
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

	def valid_number_of_params?(cmd,params,number)
		raise ArgumentError, "Invalid number of params, #{cmd.upcase} takes #{number} parameters" if params.nil? || params.length != number
	end

	def valid_image?
		raise RuntimeError, 'No image. Create one with I' if  @image.nil?
	end

	def valid_size?(params)
		raise RuntimeError, 'Invalid image size, please create an image of less than 250 x 250 px' if params.any?{|param| param >  MAX_SIZE}
	end

	def i(params)
		valid_number_of_params?(__method__,params,2)
		valid_size?(params)
		return 'Image already created, use C to clear' unless  @image.nil?
		@image = Image.new(params[0],params[1])
	end

	def c(*params)
		valid_image?
		@image = Image.new(@image.m,@image.n)
	end

	def l(params)
		valid_image?
		valid_number_of_params?(__method__,params,3)
		coords = valid_coords?(params.shift(2))
		color = valid_color?(params.first)
		@image.color_pixel!(coords,color)
	end
	
	def v(params)
		valid_image?
		valid_number_of_params?(__method__,params,4)
		valid_coords?([params[0],params[1]])
		valid_coords?([params[0],params[2]])
		color = valid_color?(params[3])
		@image.draw_vertical_line!(params[0],params[1],params[2],color)
	end

	def h(params)
		valid_image?
		valid_number_of_params?(__method__,params,4)
		valid_coords?([params[0],params[2]])
		valid_coords?([params[1],params[2]])
		color = valid_color?(params[3])
		@image.draw_horizontal_line!(params[2],params[0],params[1],color)
	end

	def f(params)
		valid_image?
		valid_number_of_params?(__method__,params,3)
		coords = valid_coords?(params.shift(2))
		color = valid_color?(params.first)
		@image.color_fill!(coords,colour)
	end

	def s(*params)
		valid_image?
		puts @image
	end

	def e(*params)
		puts 'Thanks for using Graphical editor'
		exit
	end
end