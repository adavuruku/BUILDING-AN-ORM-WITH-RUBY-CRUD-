class Ft
    
    def initialze(se)
        @comb = " come"
    end
    def ego(h)
        p "hello #{@comb}"
    end
end

f = Ft.new
f.ego("sherif")


def wel(*go)
    if go.flatten.include? "*"
        p "e dey"
    else
        p go.flatten
    end
end
d = "*"
wel(d)

wel ="SELECT ab,got,get FROM kole JOIN peter on name = persons WHERE salma = 'coledge homes' ORDERBY school desc"
hy = wel.scan(/'([^']+)'|(\S+)|(\",")/).flatten.compact
p hy[1]
ind = hy.find_index{|v| v.casecmp("JOIN").zero?}
p ind
require 'csv'
wel.parse_csv(:col_sep=> " ", :quote_char =>"'")
puts wel


p "salama homes "=~ /homes/

p "Come".casecmp("CoMe").zero?

y = "welcpme, 'home of, recordes'".split(/'([^']|'[^']*')*?(,)/)

#(/'([^']+)'|(\S+)/)
p  y

jn = "cobel" + ".scx"

p jn