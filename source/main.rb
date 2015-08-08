require_relative 'classes'
require_relative 'dictConsole'
require_relative 'wordAnalytics'
require_relative 'synth'
f = 'sentences.txt'


welcome = "\nWelcome to the Sentence Command Console.  Please enter 'help' for a list of availible commands.\n"
puts welcome
puts ""

commands = {
	add: "Create a new sentence, add it to the database.",
	batch: "Input batch of sentences.",
	clear: "Clears the terminal window.",
	dict: "Enter the Dictionary Control Console.",
	error: "Lists possible errors.\n    Use 'log' argument to print error log.",
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
			commands.each{|k, v| puts "-#{k.to_s}: #{v}"}
			
		when /intro/
			puts welcome
			puts ""
			
		when /list/
			if numIn == 1
				list.each{|i| puts "\n#{i.string}"}
			elsif usrArr[1] == "-a"
				n = 0
				list.each do |i|
					puts "==========[#{n}]=========="
					puts i.string
					d = i.data
					puts "Punctuation: #{d[:punct]}"
					print "Words:       "
					d[:words].each do |word|
						print "#{word.string} "
					end
					print "\nLength:      #{d[:length]}\n"
					puts
				end
			end
			
		when /clear/
			puts "\e[H\e[2J"

		when /error/
			if numIn == 2
				if usrArr[1] == "log"
					$log.each do |s|
						puts "Error ##{s[0]} @ #{s[1]}:"
						puts $errors[s[0]]
						puts ""
					end
				else
					$errors.each{|e, s| puts "#{e}: #{s}"}
				end
			else
					$errors.each{|e, s| puts "#{e}: #{s}"}
			end
			
		#===Console navigation functions===#
			
		when /dict/
			puts "Loading Dictionary Control Console..."
			killBool = dictConsole
			puts ""
			puts "Loading Sentence Command Console..."
			puts welcome
			
		when /data/
			puts "Loading Data Analytics Console..."
			killBool = wordAnalytics
			puts "Loading Sentence Command Console..."
			puts welcome
			
		when /synth/
			puts "Loading Sentence Synthesizer..."
			killBool = synth
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

			list = load("sentences.txt")
			str.gsub!(//, )
			str.gsub!(/[^a-zA-Z\s.!?"]/, "")
			str2 = str.split(".")
			
			str2.each do |sent|
				sent[sent.length] = "."
				sent = sent.strip
				puts sent
				n = add(Sentence.new(sent), list)
				save(n, 'sentences.txt')
			end
		
		else
			log = error(101, $errors, $log)
			
	end
	puts ""
	if killBool
		puts "\e[H\e[2J"
		break
	end
end
	