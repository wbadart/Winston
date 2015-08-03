require_relative 'classes'

sentence = "The quick brown fox jumps over a lazy dog."

str = sentence[0...-1]
str.tr!(",", "")
str = str.downcase.split(" ")
dict = []
newList = []
n = 0
str.each do |word|
	data = Word.new(word, n.to_i)
	newList = add(data, dict)
	n += 1
end

sent = Sentence.new(sentence)
newData = []
newData[0] = sent
save(newData, 'sentences')
save(newList, 'dictionary')


# "\nNon-mode disadvantage (0-100): "
modeW = (100 - 20) / 100
# "\nFrequency advantage (0-100): "
lenW = 50 / 100000
# "\nRandom min(0-100): "
randmin = 5 / 10
# "\nRandom max (0-100): "
randmax = 10
params = {
	modeW: modeW,
	lenW: lenW,
	randmin: randmin,
	randmax: randmax
}
paramLog = [params]
save(paramLog, 'parameter_log')