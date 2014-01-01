require_relative '../lib/image'

describe Image do
	let(:image_4_by_6){Image.new(4,6)}
	context 'creation' do 
		it 'should include m (horizontal) and n (veritcal) dimensions ' do
			expect(image_4_by_6.m).to eq(4)
			expect(image_4_by_6.n).to eq(6)
		end
	end

	context 'knowledge' do
		it 'should know the belonging of a pixel  in an image' do
				expect(image_4_by_6.contain?([3,4])).to be_true
				expect(image_4_by_6.contain?([5,5])).to be_false
				expect(image_4_by_6.contain?([3,8])).to be_false
				expect(image_4_by_6.contain?([8,8])).to be_false
		end

		it 'should know how to color of a pixel' do
			image_4_by_6.color_pixel!([3,4],'A')
			expect(image_4_by_6.pixel_color([3,4])).to eq('A')				
		end	

		it 'should know how to draw a vertical line' do
			image_4_by_6.draw_vertical_line!(3,3,5,'B')
			expect(image_4_by_6.pixel_color([3,3])).to eq('B')
			expect(image_4_by_6.pixel_color([3,4])).to eq('B')
			expect(image_4_by_6.pixel_color([3,5])).to eq('B')
			expect(image_4_by_6.pixel_color([2,3])).to eq('O')
			expect(image_4_by_6.pixel_color([4,3])).to eq('O')
		end	

		it 'should know how to draw a horizontal line' do
			image_4_by_6.draw_horizontal_line!(5,1,3,'B')
			expect(image_4_by_6.pixel_color([1,5])).to eq('B')
			expect(image_4_by_6.pixel_color([2,5])).to eq('B')
			expect(image_4_by_6.pixel_color([3,5])).to eq('B')
			expect(image_4_by_6.pixel_color([2,3])).to eq('O')
			expect(image_4_by_6.pixel_color([4,3])).to eq('O')
		end	
	end

	context 'presentation' do
	 it 'is represented as an M x N array of pixels set to \'O\'' do
	 	expect(image_4_by_6.to_s).to eq("OOOO\nOOOO\nOOOO\nOOOO\nOOOO\nOOOO\n")
	 end

	 it 'should color a pixel at a defined coordinates' do
	 	image_4_by_6.color_pixel!([3,4],'A')
	 	expect(image_4_by_6.to_s).to eq("OOOO\nOOOO\nOOOO\nOOAO\nOOOO\nOOOO\n")
	 end

	 it 'should draw a vertical line' do
	 	image_4_by_6.draw_vertical_line!(3,3,5,'B')
	 	expect(image_4_by_6.to_s).to eq("OOOO\nOOOO\nOOBO\nOOBO\nOOBO\nOOOO\n")
	 end

	 	 it 'should draw a horizontal line' do
	 	image_4_by_6.draw_horizontal_line!(5,1,3,'B')
	 	expect(image_4_by_6.to_s).to eq("OOOO\nOOOO\nOOOO\nOOOO\nBBBO\nOOOO\n")
	 end

	 it 'should find adjacent pixels with the same color' do
	 	image_4_by_6.color_pixel!([3,4],'B')
	  expect(image_4_by_6.touching_identical_pixel([3,4])).to eq([])
	  image_4_by_6.color_pixel!([2,4],'B')
	  expect(image_4_by_6.touching_identical_pixel([3,4])).to eq([[2,4]])
	  image_4_by_6.color_pixel!([1,2],'B')
	  expect(image_4_by_6.touching_identical_pixel([3,4])).to eq([[2,4]])
	  image_4_by_6.color_pixel!([3,3],'B')
	  expect(image_4_by_6.touching_identical_pixel([3,4])).to eq([[2,4],[3,3]])
	  image_4_by_6.color_pixel!([3,5],'B')
	  expect(image_4_by_6.touching_identical_pixel([3,4])).to eq([[2,4],[3,3],[3,5]])
	  image_4_by_6.color_pixel!([4,4],'B')
	  expect(image_4_by_6.touching_identical_pixel([3,4])).to eq([[2,4],[3,3],[3,5],[4,4]])
		end

		it 'should color-fill adjacent_cell_with_same_color' do 
			image_4_by_6.color_pixel!([2,3],'B')
			image_4_by_6.color_pixel!([2,4],'B')
			image_4_by_6.color_fill!([3,4],'C')
			expect(image_4_by_6.to_s).to eq("CCCC\nCCCC\nCBCC\nCBCC\nCCCC\nCCCC\n")
		end
	end
end