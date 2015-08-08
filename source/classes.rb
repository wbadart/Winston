$log = []
$errors = {
	101=> "Invalid input from root command. See 'help' for valid commands.",
	102=> "Invalid input to function.",
	201=> "Possible duplicate entry.",
	202=> "Entry not found.",
	301=> "Unknown error."
}





#====Searches for an item in a list.====#
#item: the needle/ search term
#list: the haystack/ set of items
#method: optional parameter that adjusts return

def exists?(item, list, *method)
	i = 0
	out = false
	list.each do |s|
		if item == s.string
			if method[0] == "find"
				out = i.to_i
			else
				out = true
			end
			break
		else
			out = false
		end
		i += 1
	end
	return out
end


#====Alphabetizes a given list using bubble sort method.====#
#list: the set of items to alphabetize
#untested but theoretically possible: sorting numbers

def sort(list)
	n = list.length - 1
	n.times do |i|
		item = list[i]		#selects the nth
		item2 = list[i + 1]	#and n+1th items in the list
		noSort = false
		until noSort
			j = 0
			loop do
				puts "#{item.string} vs #{item2.string}"
				if list[i].string[j] > list[i + 1].string[j]
					list[i] = item2
					list[i + 1] = item
					noSort = false
					break
				elsif item.string[j] == item2.string[j]
					j += 1
					if item2.string[j] == nil
						list[i] = item2
						list[i + 1] = item
						noSort = true
						break
					elsif item.string[j] == nil
						noSort = true
						break
					end
				else
					noSort = true
					break
				end
				
			end
		end
	end
	return list
end


#====Allows the editing of data within the lists.====#
#item: the object being edited
#list: the array to which it belongs
#data: new value for the field
#method: specify "d" to edit data. String is default

def edit(item, list, data, *method)
	i = exists?(item, list, "find")
	unless i.is_a? Integer
		return false
	else
		if method[0] == "d"
			list[i].data = data
		else
			list[i].string = data
		end
		return list
	end
end


#====Adds a new item to a specified list====#
#it's really straight forward

def add(item, list)
	if exists?(item, list)
		return false
	else
		list.push(item)
		return list
	end
end

#==Finds data associated with search term==#
def search(item, list)
	n = exists?(item, list, "find")
	if n == false
		return false
	else
		return list[n].data
	end
end


#==Removes item from given list====#
def delete(item, list)
	n = exists?(item, list, "find")
	if n == false
		return false
	else
		list.delete_at(n)
		return list
	end
end


#==Saves data (var) to file (file)==#
def save(var, file)
	dat = Marshal.dump(var)
	IO.binwrite(file, dat)
end

#==Loads and unserializes data from file (f)==#
def load(file)
	dat = IO.binread(file)
	return Marshal.load(dat)
end


def error(int, errArr, log)
	time = Time.now
	puts "Error ##{int.to_s}:"
	puts errArr[int]
	log.push([int, time])
	return log
end


''''''''''''''''''''''''''''''
#====Math Functions====#

def avg(set)
	sum = set.inject{|sum,x| sum + x }
	return sum/set.length
end

def mode(set)
	return set.group_by{|e| e}.max_by{|k, v| v.length}.first
end

def variance(set)
	diffs = []
	mean = avg(set)
	set.each{|n| diffs.push((mean - n)**2)}
	return avg(diffs)
end

def standarddev(set)
	return variance(set) ** 0.5
end

def max(set, *method)
	max = 0
	set.each do |n|
		max = n if n > max
	end
	return max
end

#================Custom Classes===============================#

class CustomObj
	attr_accessor :data, :string
end

class Word < CustomObj
	def initialize(string, *pos)
		@data = []
		@string = string
		@data[0] = pos[0] if pos.is_a? Array
	end
end

class Sentence < CustomObj
	def initialize(string)
		@string = string
		@data = Hash.new
		@data[:punct] = string.to_s[string.to_s.length - 1]
		str = string.to_s[0...-1]
		str.tr!(",", "")
		str = str.downcase.split(" ")

		words = []
		n = 0
		str.each do |word|
			dict = load('dictionary.txt')
			i = exists?(word, dict, "find")
			if i == false
				data = Word.new(word, n.to_i)
				dict = add(data, dict)
			else
				dict[i].data.push(n)
				data = dict[i]
			end
			save(dict, 'dictionary.txt')
			words.push(data)
			n += 1
		end
		@data[:words] = words
		@data[:length] = words.length
	end

end