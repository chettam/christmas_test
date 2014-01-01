class Image

	def initialize(m,n)
		@pixels = Array.new(m){Array.new(n){'O'}}
	end

	def m
		@pixels.size
	end

	def n
		@pixels.first.size
	end

	def contain?(pixel_coords)
		x , y = pixel_coords
		(x <= m && x >=0) && (y <= n && x >=0)
	end


end