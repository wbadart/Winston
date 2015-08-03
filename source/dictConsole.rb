def dictConsole

require_relative 'classes'
f = 'dictionary'
log = []

welcome = "\nWelcome to the Dictionary Control Console.  Here, you can add, delete,  and modify entries in the dictionary data file.  Enter 'help' at any time for a list of availible commands."
puts welcome
puts ""

commands = {
	#add: "Add a word to the dictionary.",
	clear: "Clears the terminal window.",
	del: "Remove a word from the dictionary.",
	edit: "Change the spelling or data of a word.",
	error: "List all possible error messages. Add 'log' to view it.",
	intro: "Reprints welcome message.",
	list: "Prints dictionary.",
	search: "Finds data associated with word.",
	sort: "Alphabetizes the dictionary.",
	quit: "Exit the program."
}

errors = {
	101=> "Invalid input from root command. See 'help' for valid commands.",
	102=> "Invalid input to function.",
	201=> "Possible duplicate entry.",
	202=> "Entry not found.",
	301=> "Unknown error."
}

loop do
	print ">> "
	usrIn = gets.chomp.strip.downcase
	if usrIn == "init"
		print "First word: "
		str = gets.chomp.downcase
		puts ""
		save([Word.new(str, nil)], f)
	end
	dict = load(f)
	
	usrArr = usrIn.split(" ")
	numIn = usrArr.length
	
	case usrArr[0]
		
		#===Listing/ printing functions===#
		
		when /help/
			puts "Availible commands:"
			commands.each do |k, v|
				puts "-#{k.to_s}: #{v}"
			end
			
		when /list/
			dict.each do |w|
				puts "Word: #{w.string} |  Data: #{w.data}"
			end
			
		when /clear/
			puts "\e[H\e[2J"
			
		when /intro/
			puts welcome
			
		when /error/
			if usrArr[1] == "log"
				log.each do |s|
					puts "Error ##{s[0]} @ #{s[1]}:"
					puts errors[s[0]]
				end
			else
				errors.each{|e, s| puts "#{e}: #{s}"}
			end
			
		#==-=Data manipulation functions===#
		
		when /add/
			if numIn == 2
				word = usrArr[1]
			elsif numIn == 1
				print "Word to add: "
				word = gets.chomp.downcase
			else
				log = error(102, errors, log)
			end
			add(word, dict, "word")
			list = add(str, dict)
			unless list == false
				save(list, f)
			else
				log = error(201, errors, log)
			end
			
		when /del/
			if numIn == 2
				word = usrArr[1]
			elsif numIn == 1
				print "Word to delete: "
				word = gets.chomp.strip.downcase
			else
				log = error(102, errors, log)
			end
			list = delete(word, dict)
			unless list == false
				save(list, f)
			else
				log = error(202, errors, log)
			end
			
		when /sort/
			print "Cycles (dict len = #{dict.length}): "
			n = gets.chomp.to_i
			n.times do 
				sorted = sort(dict)
				save(sorted, f)
			end
			
		when /edit/
			if numIn == 3
				item = usrArr[1]
				data = usrArr[2]
			elsif numIn == 1
				if numIn == 2
					item = usrArr[1]
				else
					print "Entry to edit: "
					item = gets.chomp.strip.downcase
				end
				print "Field to edit (s/d): "
				method = gets.chomp.strip
				if method == "d"
					puts "\nEnter new values. Enter q when done"
					data = []
					b = 0
					loop do
						print "[#{b}]=> "
						newVal = gets.chomp
						if newVal == "q"
							break
						else 
							data.push(newVal.to_i)
						end
						b += 1
					end
				else
					print "New string: "
					data = gets.chomp.strip.downcase
				end
			else
				log = error(102, errors, log)
			end
			list = edit(item, dict, data, method)
			unless list == false
				save(list, f)
				puts ""
			else
				log = error(202, errors, log)
			end
			
		when /search/
			if numIn == 2
				item = usrArr[1]
			elsif numIn == 1
				print "Search term: "
				item = gets.chomp.strip.downcase
			else
				log = error(102, errors, log)
			end
			data = search(item, dict)
			unless data == false
				puts "Word: #{item}....Data: #{data}"
			else
				log = error(202, errors, log)
			end
			
		#===A winner don't never quit===#
		when /quit/
			return true if usrArr[1] = '-a'
			break
			
		else
			log = error(101, errors, log) if usrIn != "init"
	end
	puts ""
end

end