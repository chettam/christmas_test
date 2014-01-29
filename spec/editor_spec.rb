require_relative '../lib/editor'
require_relative './spec-helper' # by convention, spec_helper has an underscore, not a dash

describe Editor  do
	let(:editor){Editor.new}
	let(:editor_with_image){editor.execute('I 4 6'); editor}

	context 'creation' do 

		it 'should include a welcome message  and prompt user input' do
			printed = capture_stdout{ editor}
			printed.should include('Graphical Editor. Available Commands')
		end

		it 'should include all the available commands' do
			printed = capture_stdout{ editor}
			Editor::COMMANDS.each {|shortcut,desc|  printed.should include("\t#{shortcut} => #{desc}")}
		end
	end

	context 'knowledge' do

		it 'should know how to parse a string to an array of command and paramters' do
			expect(editor.parse('I 200 200')).to eq(['I',200,200])
			expect(editor.parse('C')).to eq(['C'])
			expect(editor.parse('L 2 3 A')).to eq(['L',2,3,'A'])
			expect(editor.parse('V 2 54 58 B')).to eq(['V',2,54,58,'B'])
			expect(editor.parse('H 45 50 50 B')).to eq(['H',45,50,50,'B'])
			expect(editor.parse('F 100 100 B')).to eq(['F',100,100,'B'])
			expect(editor.parse('S')).to eq(['S'])
		end
	end

	context 'input validation' do

		it 'should  re prompt if the command is empty' do 
			expect(editor.execute('')).to eq('Please enter a valid command')
		end

		it 'should  re prompt if the command is using special caraters' do 
			expect(editor.execute('\t')).to eq('Please enter a valid command')
			expect(editor.execute('\t\r')).to eq('Please enter a valid command')
		end

		it 'should re prompt if the first parameter is incorrect' do
			invalid_commands = ['A','B','D','G','J','K','M','N','O','P','T','U','W','X','Y','Z']
			invalid_commands.each{|command| expect(editor.execute(command)).to eq('Invalid command, please enter a valid command') }
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
				expect(editor.execute(char)).to eq('Invalid command, please enter a valid command')
			end
		end

		it 'should re prompt  if an invalid color is used ' do 
			invalid_colors =['2','a','$','<','>']
			invalid_colors.each{|color| expect(lambda{editor.valid_color?(color)}).to raise_error}
		end
	end

	context 'command_i' do

		it 'should not  create an image if m or n are more than 250px' do 
      printed = capture_stdout do
        editor.execute('I 300 100')
        editor.execute('I 100 300')
      end
      printed.should include('Invalid image size, please create an image of less than 250 x 250 px')
    end


    it 'should take 2 params' do
      printed = capture_stdout do
        editor.execute('I')
        editor.execute('I 1 2 3 ')
        end
        printed.should include('Invalid number of params')
      end

      it 'should not create an image if one already exist' do
        printed = capture_stdout do
          editor.execute('I 10 10')
          puts editor.execute('I 20 20')
        end
        printed.should include('Image already created, use C to clear')
      end
    end

    context 'command_c' do

      it 'should clear an image' do
       printed = capture_stdout do
         editor_with_image.execute('L 1 1 A')
         editor_with_image.execute('C')
         editor_with_image.execute('S')
       end
       printed.should include("OOOO\nOOOO\nOOOO\nOOOO\nOOOO\nOOOO\n")
     end

     it 'should not clear an image if no image exist' do
      printed = capture_stdout do
        editor.execute("C")
      end
      printed.should include('No image. Create one with I')
    end
  end

  context 'command_s' do

    it 'should not display an image if no image exist' do
      printed = capture_stdout do
        editor.execute("S")
      end
      printed.should include('No image. Create one with I') 
    end

    it 'should display an image if available' do 
     printed = capture_stdout do
      editor_with_image.execute('I 4 6 ')
      editor_with_image.execute('L 1 1 A')
      editor_with_image.execute('S')
    end
    printed.should include("AOOO\nOOOO\nOOOO\nOOOO\nOOOO\nOOOO\n")
    end
  end

  context 'command_l' do

    it 'require an existing image' do
      printed = capture_stdout do
        editor.execute('L 1 2 A')
      end
      printed.should include('No image. Create one with I')
    end

    it 'require 3 paramters' do
      printed = capture_stdout do
        editor_with_image.execute('L')
        editor_with_image.execute('L 1 2')
      end
      printed.should include('Invalid number of params')
    end

    it 'require validate coordinates' do
      printed = capture_stdout do
        editor_with_image.execute('L 100 200 A')
      end
      printed.should include('Invalid coordinates')
    end

    it 'require valid color' do
      printed = capture_stdout do
        editor_with_image.execute('L 3 2 2')
      end
      printed.should include('Invalid color')
    end
  end

  context 'command_v' do

    it 'require an existing image' do
      printed = capture_stdout do
        editor.execute('V 1 2 3 A')
      end
      printed.should include('No image. Create one with I')
    end

    it 'require 4 paramters' do
      printed = capture_stdout do
        editor_with_image.execute('V')
        editor_with_image.execute('V 1 2')
      end
      printed.should include('Invalid number of params')
    end

    it 'require validate coordinates' do
      printed = capture_stdout do
        editor_with_image.execute('V 100 200 200 A')
      end
      printed.should include('Invalid coordinates')
    end

    it 'require valid color' do
      printed = capture_stdout do
        editor_with_image.execute('V 2 3 4 2')
      end
      printed.should include('Invalid color')
    end
  end

  context 'command_h' do

    it 'require an existing image' do
      printed = capture_stdout do
        editor.execute('H 1 2 3 A')
      end
      printed.should include('No image. Create one with I')
    end

    it 'require 4 paramters' do
      printed = capture_stdout do
        editor_with_image.execute('H')
        editor_with_image.execute('H 1 2')
      end
      printed.should include('Invalid number of params')
    end

    it 'require validate coordinates' do
      printed = capture_stdout do
        editor_with_image.execute('H 100 200 200 A')
      end
      printed.should include('Invalid coordinates')
    end

    it 'require valid color' do
      printed = capture_stdout do
        editor_with_image.execute('H 2 3 4 2')
      end
      printed.should include('Invalid color')
    end
  end

  context 'command_f' do

    it 'require an existing image' do
      printed = capture_stdout do
        editor.execute('F 1 2 A')
      end
      printed.should include('No image. Create one with I')
    end

    it 'require 4 paramters' do
      printed = capture_stdout do
        editor_with_image.execute('F')
        editor_with_image.execute('F 1 2')
      end
      printed.should include('Invalid number of params')
    end

    it 'require validate coordinates' do
      printed = capture_stdout do
        editor_with_image.execute('F 100 200 A')
      end
      printed.should include('Invalid coordinates')
    end

    it 'require valid color' do
      printed = capture_stdout do
        editor_with_image.execute('F 2 3 2')
      end
      printed.should include('Invalid color')
    end
  end
end
