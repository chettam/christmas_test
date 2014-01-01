class Image

	def initialize(m,n)
		@pixels = Array.new(n){Array.new(m){'O'}}
	end

	def n
		@pixels.size
	end

	def m
		@pixels.first.size
	end

	def contain?(pixel_coords)
		x , y = pixel_coords
		(x <= m && x >=0) && (y <= n && x >=0)
	end

	def color_pixel!(pixel_coords,color)
		@pixels[pixel_coords[1] -1][pixel_coords[0] -1] = color	
	end

	def draw_vertical_line!(x,y1,y2,color)
			(y1..y2).each do |y| 
				color_pixel!([x,y],color) if contain?([x,y])
			end
	end

	def draw_horizontal_line!(y,x1,x2,color)
			(x1..x2).each do |x| 
				color_pixel!([x,y],color) if contain?([x,y])
			end
	end

	def color_fill!(pixel_coords,color)
		initial_pixel_color = pixel_color(pixel_coords)
		color_pixel!(pixel_coords,color)
		touching_identical_pixel(pixel_coords,initial_pixel_color).each do |pixel_coords|
			color_fill!(pixel_coords,color) if pixel_color(pixel_coords) != color
		end
	end

	def pixel_color(pixel_coords)
		@pixels[pixel_coords[1] -1][pixel_coords[0] -1]
	end

	def touching_identical_pixel(pixel_coords,color =nil)
		color ||= pixel_color(pixel_coords)
		x, y = pixel_coords
		candidate_pixels = [[x-1,y],[x+1,y],[x,y-1],[x,y+1]]
		candidate_pixels.select do |candidate_pixel| 
			pixel_color(candidate_pixel) == color && contain?(candidate_pixel)
		end.sort
	end

	def to_s
		@pixels.map { |row| "#{row.join}\n" }.join
	end
end