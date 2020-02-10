wel = "update ruby set adams = ' male',deje  = 'malrfrog coms', derek='fatony ibo' where den = 'calbury uni'"
.gsub("="," = ")
del = wel.scan(/'([^']+)'|(\S+)/).flatten.compact.map{|v| v.split(",")}.flatten.select{|j| j.length>0}
p del
if(del[0].casecmp("UPDATE").zero? and del[2].casecmp("SET").zero? )
    fields ={}

    from_table = del[1]
    startV = del.find_index{|v| v.casecmp("set").zero?} + 1
    endV = del.find_index{|v| v.casecmp("where").zero?} != nil ? del.find_index{|v| v.casecmp("where").zero?} : del.length
    
    #preparing the fields
    while startV < endV
        fields[del[startV]] = del[startV + 2]
        startV+=3
    end

    #prep where
    where =0
    column_name =column_value =""
    if (wel =~ /WHERE/i) != nil
        where = del.find_index{|v| v.casecmp("WHERE").zero?}
        column_name = del[where+1]
        column_value = del[where+3]
    end

    MySqliteRequest("nba_player_data.csv")
    .update(fields)
    .from(from_table)
    .where(column_name,column_value).run

    p fields
    p column_name
    p column_value
end