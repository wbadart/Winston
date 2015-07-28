require_relative 'classes'

puts "\nData Analytics Console. Enter 'help' to get started."
puts ""

loop do
	list = load('dictionary')
	print "[data]>> "
	usrIn = gets.chomp.strip.downcase
	usrArr = usrIn.split(" ")
	numIn = usrArr.length
	
	case usrArr[0]
		when /select/
			if numIn == 2
				item = usrArr[1]
			elsif numIn == 1
				print "Word to select: "
				item = gets.chomp.strip.downcase
			else
				error(102, $errors, $log)
				item = :foo
			end
			n = exists?(item, list, "find")
			unless n == false
				puts "#{list[n].string.upcase}:"
				puts "Data preview:     #{list[n].data[0..10]}"
				puts "Average position: #{avg(list[n].data)}"
				puts "Mode position:    #{mode(list[n].data)}"
				puts "Variance:         #{variance(list[n].data)}"
				puts "Sigma:            #{standarddev(list[n].data)}"
				puts""
			else
				error(202, $errors, $log)
			end
			
		when /quit/
			break
			
		else
			error(101, $errors, $log)
			
	end
	puts ""
end