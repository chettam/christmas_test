require_relative '../lib/editor'

describe Editor  do
	let(:editor){Editor.new}

	context 'creation' do 
		it 'should include a welcome message  and prompt user input' do
			STDOUT.should_receive(:write).with("Graphical Editor. Available Commands")
		end

		# it 'should include all the available commands' do
		# 	Editor::COMMANDS.each do |shortcut,desc| 
		# 		STDOUT.should_receive(:write).with(shortcut)
		# 		STDOUT.should_receive(:write).with(desc)
		# 	end
		# end
	end
end