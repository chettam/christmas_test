require_relative '../lib/image'

describe Image do
	let(:image_4_by_6){Image.new(4,6)}
	context 'creation' do 
		it 'should include m (horizontal) and n (veritcal) dimensions ' do
			expect(image_4_by_6.m).to eq(4)
			expect(image_4_by_6.n).to eq(6)
		end
	end

	context 'Action' do
		it 'should know if a pixel is contained in an image' do
				expect(image_4_by_6.contain?([3,4])).to be_true
				expect(image_4_by_6.contain?([5,5])).to be_false
				expect(image_4_by_6.contain?([3,8])).to be_false
				expect(image_4_by_6.contain?([8,8])).to be_false
		end
	end
end