require_relative 'classes'
sentence = "The quick brown fox jumps over a lazy dog."

str = sentence[0...-1]
str.tr!(",", "")
str = str.downcase.split(" ")
dict = []
n = 0
str.each do |word|
	data = Word.new(word, n.to_i)
	dict = add(data, dict)
	n += 1
end

save(dict, 'dictionary.txt')

params = {
	modeW: 0.2,
	lenW: 0.0005,
	randmin: 5,
	randmax: 10
}
paramLog = [params]
save(paramLog, 'parameter_log.txt')
save([Sentence.new(sentence)], 'sentences.txt')