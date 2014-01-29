module Helper

  COLORS = ('A'..'Z').to_a
  MAX_SIZE = 250 # well done for using constants

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

  def parse(input)
    args = input.split(' ').map do |x| 
      Integer(x) rescue x 
    end
  end

  # This method both prints strings and returns them, it's a bit inconsistent. Bruce did the same 
  # thing, you may want to discuss it with him
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

  # a method that ends with "?" must not raise an error or return a colour, it should always return true/false
  # same for other methods
  def valid_color?(color)
  	raise ArgumentError, 'Invalid color' unless COLORS.include?(color)
  	color
  end

  def valid_coords?(coords,image)
    # indentation!
  		raise ArgumentError, 'Invalid coordinates' unless coords.length == 2 && image.contain?(coords)
  		coords
  end

  def valid_number_of_params?(cmd,params,number)
    raise ArgumentError, "Invalid number of params, #{cmd.upcase} takes #{number} parameters" if params.nil? || params.length != number
  end

  def valid_image?(image)
    raise RuntimeError, 'No image. Create one with I' if  @image.nil?
  end

  def valid_size?(params)
    raise RuntimeError, 'Invalid image size, please create an image of less than 250 x 250 px' if params.any?{|param| param >  MAX_SIZE}
  end
end