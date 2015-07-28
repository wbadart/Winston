require_relative 'classes'
list = load("sentences")

print  "[batch]>> "
str = gets("\t\n").chomp.strip

list = load("sentences")
str.gsub!(/[^a-zA-Z\s.!?"]/, "")
	puts str.split(".")
	str2 = str.split(".")
sents = []
str2.each do |sent|
	sent[sent.length] = "."
	sents.push(sent.strip)
end
	sents.each do |sent|
	n = add(Sentence.new(sent), list)
	save(n, 'sentences')
end