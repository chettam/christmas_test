require_relative '../lib/editor'
require_relative './spec-helper'

describe Editor  do
	let(:editor){Editor.new}
	let(:editor_image_4_by_6) {editor.execute("I 4 6 "); editor }

	context 'creation' do 
		it 'should include a welcome message  and prompt user input' do
			printed = capture_stdout{ editor}
			printed.should include("Graphical Editor. Available Commands\n")
		end

		it 'should include all the available commands' do
			printed = capture_stdout{ editor}
			Editor::COMMANDS.each {|shortcut,desc|  printed.should include("\t#{shortcut} => #{desc}")}
		end
	end

	context 'knowledge' do
		it 'should know how to parse a string to an array of command and paramters' do
			expect(editor.parse("I 200 200")).to eq(['I',200,200])
			expect(editor.parse("C")).to eq(['C'])
			expect(editor.parse("L 2 3 A")).to eq(['L',2,3,'A'])
			expect(editor.parse("V 2 54 58 B")).to eq(['V',2,54,58,'B'])
			expect(editor.parse("H 45 50 50 B")).to eq(['H',45,50,50,'B'])
			expect(editor.parse("F 100 100 B")).to eq(['F',100,100,'B'])
			expect(editor.parse("S")).to eq(['S'])
		end
	end

	context 'input validation' do
		it 'should  re prompt if the command is empty' do 
			expect(editor.execute('')).to eq("Please enter a valid command")
		end

		it 'should  re prompt if the command is using special caraters' do 
			expect(editor.execute('\t')).to eq("Please enter a valid command")
			expect(editor.execute('\t\r')).to eq("Please enter a valid command")
		end

		it 'should re prompt if the first parameter is incorrect' do
			invalid_commands = ['A','B','D','G','J','K','M','N','O','P','T','U','W','X','Y','Z']
			invalid_commands.each{|command| expect(editor.execute(command)).to eq("Invalid command, please enter a valid command") }
		end

		it 'should re prompt if the first parameter is incorrect' do
			incorrect_parameters = ['?','!','`','exit']
			incorrect_parameters.each {|char|  expect(editor.execute(char)).to eq('Invalid command, please enter a valid command')}
		end

		it 'should convert digit parameters to intergers' do
			expect(editor.parse("L 2 3 A")[1]).to be_a_kind_of(Integer)
			expect(editor.parse("L 2 3 A")[2]).to be_a_kind_of(Integer)
			expect(editor.parse("L 2 3 A")[3]).not_to be_a_kind_of(Integer)
		end

		it 'should re prompt if lower case characters are used' do
			('a'..'z').to_a.each do |char| 
				expect(editor.execute(char)).to eq("Invalid command, please enter a valid command")
			end
		end

		it 'should re prompt  if an invalid color is used ' do 
			invalid_colors =['2','a','$','<','>']
			invalid_colors.each{|color| expect(lambda{editor.valid_color?(color)}).to raise_error}
		end
	end

	context 'command_i' do
		it 'should not  create an image if m or n are m are more than 250px' do 
			expect(editor.execute("I 300 100")).to eq("Invalid image size, please create an image of less than 250 x 250 px")
			expect(editor.execute("I 100 300")).to eq("Invalid image size, please create an image of less than 250 x 250 px")
		end	

		it 'should take 2 params' do
			expect( lambda{editor.execute("I")}).to raise_error
			expect(editor.execute("I 1 2 3 ")).to eq("Invalid number of params")
		end

		it 'should not create an image if one already exist' do
			editor.execute("I 10 10")
			expect(editor.execute("I 20 20")).to eq("Image already created, use c to clear")
		end
	end

	context 'command_c' do
		it 'should clear an image if no image exist' do
			printed = capture_stdout do
				editor_image_4_by_6.execute("L 1 1 A")
				editor_image_4_by_6.execute("C")
				editor_image_4_by_6.execute("S")
			end
			printed.should include("OOOO\nOOOO\nOOOO\nOOOO\nOOOO\nOOOO\n")
		end

		it 'should not clear an image if no image exist' do
			expect(editor.execute("C")).to eq("no image to clear")
		end
	end
	context 'command_s' do
		it 'should not display an image if no image exist' do
			expect(editor.execute("S")).to eq('No Image, please create an image first')
		end

		it 'should display an image if available' do 
			printed = capture_stdout do
				editor_image_4_by_6.execute("I 4 6 ")
				editor_image_4_by_6.execute("L 1 1 A")
				editor_image_4_by_6.execute("S")
			end
			printed.should include("AOOO\nOOOO\nOOOO\nOOOO\nOOOO\nOOOO\n")
		end
	end

	context 'command_l' do

		it "require an existing image" do
			expect(editor.execute("L 1 2 A")).to eq("no image")
		end

		it "require 3 paramters" do
			expect(lambda{editor_image_4_by_6.execute("L")}).to  raise_error
			expect(editor_image_4_by_6.execute("L 1 2")).to eq("Invalid number of params")
		end

		it "require validate coordinates" do 
			expect(lambda{editor_image_4_by_6.execute("L 100 200 A")}).to raise_error
		end

		it "require valid color" do 
			expect(lambda{editor_image_4_by_6.execute("L 100 200 2")}).to raise_error
		end

	end

	context 'command_v' do

		it "require an existing image" do 
			expect(editor.execute("V 1 2 3 A")).to eq("no image")
		end

		it "require 4 paramters" do
			expect(lambda{editor_image_4_by_6.execute("V")}).to  raise_error
			expect(editor_image_4_by_6.execute("V 1 2")).to eq("Invalid number of params")
		end

		it "require validate coordinates" do 

		end

		it "require valid color" do 

		end

	end

	context 'command_h' do

		it "require an existing image" do
			expect(editor.execute("H 1 2 3 A")).to eq("no image")
		end

		it "require 4 paramters" do 
			expect(lambda{editor_image_4_by_6.execute("H")}).to  raise_error
			expect(editor_image_4_by_6.execute("H 1 2")).to eq("Invalid number of params")
		end

		it "require validate coordinates" do

		end

		it "require valid color" do 

		end

	end

	context 'command_f' do

		it "require an existing image" do
			expect(editor.execute("F 1 2 A")).to eq("no image")
		end

		it "require 4 paramters" do
			expect(lambda{editor_image_4_by_6.execute("F")}).to  raise_error
			expect(editor_image_4_by_6.execute("F 1 2")).to eq("Invalid number of params")
		end

		it "require validate coordinates" do

		end

		it "require valid color" do

		end

	end
end