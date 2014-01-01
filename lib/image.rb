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

	def pixel_color(pixel_coords)
		@pixels[pixel_coords[1] -1][pixel_coords[0] -1]
	end

	def adjacent_cell_with_same_color(pixel_coords)
		color = pixel_color(pixel_coords)
		x, y = pixel_coords
		cells = [[x-1,y],[x+1,y],[x,y-1],[x,y+1]]
		cells.select{|cell| pixel_color(cell) == color && contain?(cell)}.sort
	end

	def to_s
		@pixels.map { |row| "#{row.join}\n" }.join
	end
end