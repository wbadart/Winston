def synth

require_relative 'classes'
f = ['dictionary.txt', 'sentences.txt', 'parameter_log.txt']
puts "\nWelcome to the Sentence Synthesizer.  Type 'quit' at any time to leave. First input is sentence length. Second is method. Method 1 uses a simple mode analysis and Method 2 uses score generation with chaos."
puts ""

def useOld(i)
	return paramLog[i]
end
def listParam
	i = 0
	$paramLog.each do |k, v|
		puts "===========[#{i}]==========="
		puts "#{k}: #{v}"
		puts ""
		i += 1
	end
end

loop do
	print "[synth]>> "
	usrIn = gets.chomp.strip.downcase
	usrArr = usrIn.split(" ")
	numIn = usrArr.length
	$paramLog = load(f[2])
	
	case usrArr[0]
		when /help/
			puts "help selected"
		
		when /quit/
			return true if usrArr[1] == '-a'
			break
			
		when /param/
			listParam
			
		when /new/
			print "Sentence length: "
			len = gets.chomp.to_i
			break if len == 0
			print "Method: "
			method = gets.chomp.strip.downcase
			list = load(f[0])
			sent = []
			
			while method =~ /param/
				listParam
				print "Method: "
				method = gets.chomp.strip
			end
			
			case method				
				when /1/
					len += 1
					len.times do |i|
						maxN = 0
						for item in list
							tot = item.data.select{ |n| n==i}
							if tot.empty?
								next
							else
								if tot.inject{|sum,x| sum + x } > maxN and not sent.include? item.string
									maxN = tot.inject{|sum,x| sum + x }
									sent[i] = item.string
								end
							end
						end
					end
					
				when /2/
					print "Use parameter set: "
					use = gets.chomp.strip
					if use.empty?
						print "\nNon-mode disadvantage (0-100): "
						modeW = (100 - gets.chomp.strip.to_i) / 100
						print "\nFrequency advantage (0-100): "
						lenW = gets.chomp.strip.to_i / 100000
						print "\nRandom min(0-100): "
						randmin = gets.chomp.strip.to_i
						print "\nRandom max (0-100): "
						randmax = gets.chomp.strip.to_i
						params = {
							modeW: modeW,
							lenW: lenW,
							randmin: randmin,
							randmax: randmax
						}
						$paramLog.push(params)
						save($paramLog, 'parameter_log')
					else
						params = $paramLog[use.to_i]
						modeW = params[:modeW]
						lenW = params[:lenW]
						randmin = params[:randmin]
						randmax = params[:randmax]
					end
					len.times do |i|
						data = []
						sigmas = []
						for item in list
							set = item.data
							if set.include? i
								data.push(item)
								sigmas.push(standarddev(item.data))
							end
						end
						max = 0
						k = 0
						maxSig = max(sigmas) + 0.0000001
						data.each do |n|
							set = n.data
							if modeW > 0
								mode(set) == i ? score = 1 : score = modeW
							else
								score = 1
							end
							score += set.length * lenW
							nMult = standarddev(set)
							score *= 1 - nMult / maxSig
							score*= rand(randmax - randmin) + randmin
							if score > max
								max = score
								$maxIn = k
							end
							k += 1
						end
						sent.push(data[$maxIn].string)
					end
			end
				
			sent = sent.join(" ").strip.capitalize
			sent[sent.length] = "."
			puts params
			puts "\n#{sent}" if sent.length > 1
			
	end
	puts ""
end

end