require_relative 'classes'
f = 'sentences'


welcome = "\nWelcome to the Sentence Command Console.  Please enter 'help' for a list of availible commands.\n"
puts welcome
puts ""

commands = {
	add: "Create a new sentence, add it to the database.",
	batch: "Input batch of sentences.",
	clear: "Clears the terminal window.",
	dict: "Enter the Dictionary Control Console.",
	help: "List all availible commands.",
	intro: "Reprints the welcome message.",
	list: "Lists all sentences in the database.\n    Use '-a' argument to also list data.",
	quit: "Exit the console.",
	synth: "Enter Sentence Syntheiszer."
}


loop do
	print ">> "
	usrIn = gets.chomp.strip.downcase
	usrArr = usrIn.split(" ")
	numIn = usrArr.length
	
	if usrIn == "init"
		print "First sentence: "
		str = gets.chomp.strip
		save([Sentence.new(str)], f)
	end
	
	list = load(f)
	
	case usrArr[0]
		
		#===Listing/ printing functions===#
		
		when /help/
			puts "Availible commands:"
			commands.each{|k, v| puts "#{k}: #{v}"}
			
		when /intro/
			puts welcome
			puts ""
			
		when /list/
			if numIn == 1
				list.each{|i| puts "\n#{i.string}"}
			elsif usrArr[1] == "-a"
				list.each do |i|
					puts i.string
					d = i.data
					d.each do |k, v|
						if v.is_a? Array
							puts "#{k} (Array)":
							v.each{|m| puts "[#{m}]: #{v}"}
						else
							puts "#{k}: #{v}"
						end
					end
					print "\n\n\n"
				end
			end
			
		when /clear/
			puts "\e[H\e[2J"

		when /error/
			if usrArr[1] == "log"
				$log.each do |s|
					puts "Error ##{s[0]} @ #{s[1]}:"
					puts $errors[s[0]]
					puts ""
				end
			else
				$errors.each{|e, s| puts "#{e}: #{s}"}
			end
			
		#===Console navigation functions===#
			
		when /dict/
			puts "Loading Dictionary Control Console..."
			require_relative 'dictConsole'
			puts ""
			puts "Loading Sentence Command Console..."
			puts welcome
			
		when /data/
			puts "Loading Data Analytics Console..."
			require_relative 'wordAnalytics'
			puts "Loading Sentence Command Console..."
			puts welcome
			
		when /synth/
			puts "Loading Sentence Synthesizer..."
			require_relative 'synth'
			puts "Loading Sentence Command Console..."
			puts welcome
			
		when /quit/
			puts "\e[H\e[2J"
			break
		
		#===Data manipulation functions===#
		
		when /add/
			print "[add]>> "
			string = gets.chomp.strip
			listN = add(Sentence.new(string), list)
			unless listN == false
				save(listN, f)
			else
				log = error(201, $errors, $log)
			end
			
		when /del/
			if numIn == 2
				item = usrArr[1]
			elsif numIn == 1
				print "[del]>> "
				item = gets.chomp.strip.downcase
			else
				log = error(102, $errors, $log)
			end
			n = delete(item, list)
			unless n == false
				save(n, f)
			else
				log = error(201, $errors, $log)
			end
			
		when /batch/
			print  "[batch]>> "
			str = gets("\t\n").chomp.strip

			list = load("sentences")
			str.gsub!(/[^a-zA-Z\s.!?"]/, "")
				puts str.split(".")
				str2 = str.split(".")
			
			str2.each do |sent|
				sent[sent.length] = "."
				sent = sent.strip
				n = add(Sentence.new(sent), list)
				save(n, 'sentences')
			end
		
		else
			log = error(101, $errors, $log)
			
	end
	puts ""
end
	