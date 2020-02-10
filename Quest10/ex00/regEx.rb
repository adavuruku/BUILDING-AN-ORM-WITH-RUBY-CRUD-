=begin

[abc]	A single character of: a, b, or c
[^abc]	Any single character except: a, b, or c
[a-z]	Any single character in the range a-z
[a-zA-Z]	Any single character in the range a-z or A-Z
^	Start of line
$	End of line
\A	Start of string
\z	End of string
.	Any single character
\s	Any whitespace character
\S	Any non-whitespace character
\d	Any digit
\D	Any non-digit
\w	Any word character (letter, number, underscore)
\W	Any non-word character
\b	Any word boundary
(...)	Capture everything enclosed
(a|b)	a or b
a?	Zero or one of a
a*	Zero or more of a
a+	One or more of a
a{3}	Exactly 3 of a
a{3,}	3 or more of a
a{3,6}	Between 3 and 6 of a
options: i case insensitive m make dot match newlines x ignore whitespace in regex o perform #{...} substitutions only once

=end



def number_after_word?(str)
  !!(str =~ /(?<=\w) (\d+)/)
end
p number_after_word?("Grade 99")

y =[3,5,6,8,9]
p y.slice(3..6)
h ={"name"=>"Tyler Zeller", "year_start"=>"2013", "year_end"=>"2018", "position"=>"F-C", 
"height"=>"7-0", "weight"=>"253", "birth_date"=>"January 17, 1990", 
"college"=>"University of North Carolina"}.slice("name")
p h