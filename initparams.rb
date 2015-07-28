require_relative 'classes'
paramLog = []
print "\nNon-mode disadvantage (0-100): "
				modeW = (100 - gets.chomp.strip.to_i) / 100
				print "\nFrequency advantage (0-100): "
				lenW = gets.chomp.strip.to_i / 100000
				print "\nRandom min(0-100): "
				randmin = gets.chomp.strip.to_i / 10
				print "\nRandom max (0-100): "
				randmax = gets.chomp.strip.to_i
				params = {
					modeW: modeW,
					lenW: lenW,
					randmin: randmin,
					randmax: randmax
				}
				paramLog.push(params)
				save(paramLog, 'parameter_log')