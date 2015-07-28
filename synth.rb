require_relative 'classes'
f = ['dictionary', 'sentences']


loop do
	print "Sentence length: "
	len = gets.chomp.to_i
	break if len == 0
	print "Method: "
	method = gets.chomp.strip.downcase
	list = load(f[0])
	sent = []

	case method
		when /quit/
			break
		
		when /1/
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
				scores = Array.new(data.length){0}
				max = 0
				k = 0
				maxSig = max(sigmas) + 0.0001
				data.each do |n|
					set = n.data
					mode(set) == i ? score = 1 : score = 0.2
					score += set.length * 0.001
					nMult = standarddev(set)
					nMult += 0.0001 if nMult == 0
					score *= 1 - nMult / maxSig
					score*= rand(90) + 10
					puts "pos: #{i}, word: #{n.string}, score: #{score}"
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

	puts sent
	
end