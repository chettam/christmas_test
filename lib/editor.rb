require_relative 'image'
require_relative 'helper'
class Editor

	include Helper
	
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
	
	def i(params)
		valid_number_of_params?(__method__,params,2)
		valid_size?(params)
		return 'Image already created, use C to clear' unless  @image.nil?
		@image = Image.new(params[0],params[1])
	end

	def c(*params)
		valid_image?(@image)
		@image = Image.new(@image.m,@image.n)
	end

	def l(params)
		valid_image?(@image)
		valid_number_of_params?(__method__,params,3)
		coords = valid_coords?(params.shift(2),@image)
		color = valid_color?(params.first)
		@image.color_pixel!(coords,color)
	end
	
	def v(params)
		valid_image?(@image)
		valid_number_of_params?(__method__,params,4)
		valid_coords?([params[0],params[1]],@image)
		valid_coords?([params[0],params[2]],@image)
		color = valid_color?(params[3])
		@image.draw_vertical_line!(params[0],params[1],params[2],color)
	end

	def h(params)
		valid_image?(@image)
		valid_number_of_params?(__method__,params,4)
		valid_coords?([params[0],params[2]],@image)
		valid_coords?([params[1],params[2]],@image)
		color = valid_color?(params[3])
		@image.draw_horizontal_line!(params[2],params[0],params[1],color)
	end

	def f(params)
		valid_image?(@image)
		valid_number_of_params?(__method__,params,3)
		coords = valid_coords?(params.shift(2),@image)
		color = valid_color?(params.first)
		@image.color_fill!(coords,colour)
	end

	def s(*params)
		valid_image?(@image)
		puts @image
	end

	def e(*params)
		puts 'Thanks for using Graphical editor'
		exit
	end
end