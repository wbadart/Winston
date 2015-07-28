require_relative 'classes'

sentence = "The quick brown fox jumps over a lazy dog."

str = sentence[0...-1]
str.tr!(",", "")
str = str.downcase.split(" ")
dict = []
n = 0
str.each do |word|
	data = Word.new(word, n.to_i)
	newList = add(data, dict)
	save(newList, 'dictionary')
	n += 1
end

sent = Sentence.new(sentence)
newData = []
newData[0] = sent
save(newData, 'sentences')