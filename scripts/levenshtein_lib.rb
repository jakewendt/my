
class Levenshtein

	attr_accessor :word1
	attr_accessor :word2
	attr_accessor :matrix

	def initialize(word1,word2)
		self.word1 = word1
		self.word2 = word2
		self.matrix = compute_levenshtein_distance
	end

	def compute_levenshtein_distance
		m = word1.length
		n = word2.length
		d = Array.new(m+1){Array.new(n+1)}

		(0..m).each { |i| d[i][0] = i }
		(0..n).each { |j| d[0][j] = j }

		(1..m).each { |i|
			(1..n).each { |j|
				if word1.char_array[i-1] == word2.char_array[j-1]
					d[i][j] = d[i-1][j-1]
				else
					d[i][j] = [
						d[i-1][j] + 1,		#	a deletion
						d[i][j-1] + 1,		#	an insertion
						d[i-1][j-1] + 1		#	a substitution
					].min
				end
			}
		}
		d
	end

	def and_display
		puts (['-','-'] + word1.char_array).join(',')
		matrix.transpose.each_with_index { |a,i|
			puts ([(['-']+ word2.char_array)[i]] + a).join(',')
		}
		puts "#{word1} to #{word2} : #{matrix[word1.length][word2.length]}"
	end

	def distance
		matrix[matrix.length-1][matrix[0].length-1]
	end

end



String.class_eval do
	
	attr_accessor :levenshtein

	def char_array
		self.chars.to_a
	end

	def levenshtein_distance_to(other_string)
		self.levenshtein = Levenshtein.new(self,other_string)
	end

end

#'causes'.levenshtein_distance_to('casually').and_display
#'kitten'.levenshtein_distance_to('sitting').and_display
#'sitting'.levenshtein_distance_to('kitten').and_display
#'Saturday'.levenshtein_distance_to('Sunday').and_display
#'Sunday'.levenshtein_distance_to('Saturday').and_display
#'apple'.levenshtein_distance_to('grape').and_display
#'gumbo'.levenshtein_distance_to('gambol').and_display
#
#puts 'apple'.levenshtein_distance_to('grape').distance


