#!/usr/bin/env ruby
#
#	http://www.causes.com/jobs#job1
#	Software Engineer
#	
#	We’re looking for exceptional engineers to join the Causes Engineering team. You should have experience 
#	developing software in a variety of environments and should be comfortable with Linux servers, open-source 
#	databases, elegant code and efficient algorithms.
#	
#	At Causes, engineers get a chance to make an impact right away in building products for our massive user 
#	base. Ideal candidates should have:
#	
#	Ideal candidates should have:
#	
#	    4+ year college degree in computer science (or related) OR equivalent professional experience
#	    Work experience developing software in a business environment, preferably with Linux/UNIX
#	    Database, application architecture and software systems design experience
#	    Experience with at least one dynamic language (Ruby, Python, JavaScript, PHP, Perl, Scheme, Lisp, etc.)
#	    Excellent problem solving abilities, a firm grasp on algorithms and rock-solid computer science fundamentals
#	
#	Of course greatness comes in all shapes, so we keep an open mind. We encourage you to apply if you like 
#	difficult technical challenges, helping society at large and having fun with great people.
#	Like puzzles? Solve this problem to catch our attention! Be sure to follow the instructions exactly.
#	
#	Two words are friends if they have a Levenshtein distance of 1. That is, you can add, remove, or substitute 
#	exactly one letter in word X to create word Y. A word’s social network  consists of all of its friends, 
#	plus all of their friends, and all of their friends’ friends, and so on. Write a program to tell us how 
#	big the social network for the word “causes” is, using this word list. Have fun!
#	
#	Include your answer, along with your thought process, notes, and any code along with your resume.
#	
#	To Apply
#	Send your text, PDF or HTML resume to jobs@causes.com with the subject “Software Engineer Position.”
#	
#	http://en.wikipedia.org/wiki/Levenshtein_distance

#String.class_eval do
#
#	attr_accessor :other
#	attr_accessor :levenshtein_matrix
#
#	def char_array
#		self.chars.to_a
#	end
#
#	def compute_levenshtein_distance_to(other_word)
#		self.other = other_word
#		m = self.length
#		n = other.length
#		d = Array.new(m+1){Array.new(n+1)}
#
#		(0..m).each { |i| d[i][0] = i }
#		(0..n).each { |j| d[0][j] = j }
#
#		(1..m).each { |i|
#			(1..n).each { |j|
#				if char_array[i-1] == other.char_array[j-1]
#					d[i][j] = d[i-1][j-1]
#				else
#					d[i][j] = [
#						d[i-1][j] + 1,		#	a deletion
#						d[i][j-1] + 1,		#	an insertion
#						d[i-1][j-1] + 1		#	a substitution
#					].min
#				end
#			}
#		}
#		self.levenshtein_matrix = d
#		self
#	end
#
#	def and_display
#		puts (['-','-'] + char_array).join(',')
#		levenshtein_matrix.transpose.each_with_index { |a,i|
#			puts ([(['-']+ other.char_array)[i]] + a).join(',')
#		}
#		puts "#{self} to #{other} : #{levenshtein_matrix[self.length][other.length]}"
#	end
#
#end
#
#'causes'.compute_levenshtein_distance_to('casually').and_display
#'kitten'.compute_levenshtein_distance_to('sitting').and_display
#'sitting'.compute_levenshtein_distance_to('kitten').and_display
#'Saturday'.compute_levenshtein_distance_to('Sunday').and_display
#'Sunday'.compute_levenshtein_distance_to('Saturday').and_display
#'apple'.compute_levenshtein_distance_to('grape').and_display
#'gumbo'.compute_levenshtein_distance_to('gambol').and_display
#

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

words = File.readlines('levenshtein.list').collect(&:chomp!)[0..99999]

network = friends = new_friends = []

new_friends.push('causes')
begin
	puts new_friends.join(',')
	words -= new_friends
	friends_friends = []
	new_friends.each do |friend|
		puts "searching for friends of #{friend}"
		really_new_friends = words.select{|w| friend.levenshtein_distance_to(w).distance <= 1 }
		friends_friends += really_new_friends
		friends += really_new_friends
		puts "found #{really_new_friends.length} new friends (#{really_new_friends.join(',')}) of #{friend} :total friends:#{friends.length}:words:#{words.length}"
	end
	new_friends = friends_friends
end while new_friends.length > 0




__END__


				k 	i 	t 	t 	e 	n
		0 	1 	2 	3 	4 	5 	6
s 	1 	1 	2 	3 	4 	5 	6
i 	2 	2 	1 	2 	3 	4 	5
t 	3 	3 	2 	1 	2 	3 	4
t 	4 	4 	3 	2 	1 	2 	3
i 	5 	5 	4 	3 	2 	2 	3
n 	6 	6 	5 	4 	3 	3 	2
g 	7 	7 	6 	5 	4 	4 	3
	
				S 	a 	t 	u 	r 	d 	a 	y
		0 	1 	2 	3 	4 	5 	6 	7 	8
S 	1 	0 	1 	2 	3 	4 	5 	6 	7
u 	2 	1 	1 	2 	2 	3 	4 	5 	6
n 	3 	2 	2 	2 	3 	3 	4 	5 	6
d 	4 	3 	3 	3 	3 	4 	3 	4 	5
a 	5 	4 	3 	4 	4 	4 	4 	3 	4
y 	6 	5 	4 	4 	5 	5 	5 	4 	3

from http://en.wikipedia.org/wiki/Levenshtein_distance

 int LevenshteinDistance(char s[1..m], char t[1..n])
 {
   // for all i and j, d[i,j] will hold the Levenshtein distance between
   // the first i characters of s and the first j characters of t;
   // note that d has (m+1)x(n+1) values
   declare int d[0..m, 0..n]
  
   for i from 0 to m
     d[i, 0] := i // the distance of any first string to an empty second string
   for j from 0 to n
     d[0, j] := j // the distance of any second string to an empty first string
  
   for j from 1 to n
   {
     for i from 1 to m
     {
       if s[i] = t[j] then  
         d[i, j] := d[i-1, j-1]       // no operation required
       else
         d[i, j] := minimum
                    (
                      d[i-1, j] + 1,  // a deletion
                      d[i, j-1] + 1,  // an insertion
                      d[i-1, j-1] + 1 // a substitution
                    )
     }
   }
  
   return d[m,n]
 }
