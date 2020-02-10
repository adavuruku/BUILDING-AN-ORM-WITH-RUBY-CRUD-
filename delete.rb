wel = "Delete from tableName where derek ='fatony ibo' ".gsub("="," = ")
del = wel.scan(/'([^']+)'|(\S+)|(\",")/).flatten.compact
#del = wel.split(" ").map{|h| h.split(",")}.flatten.select{|y| y.length>0}
p del
if(del[0].casecmp("DELETE").zero?)
    
    from_table = del[del.find_index{|v| v.casecmp("FROM").zero?}+1]

    where =0
    column_name =column_value =""
    if (wel =~ /WHERE/i) != nil
        where = del.find_index{|v| v.casecmp("WHERE").zero?}
        column_name = del[where+1]
        column_value = del[where+3]
    end
    
    MySqliteRequest("nba_player_data.csv")
    .delete()
    .from(from_table)
    .where(column_name,column_value).run
    
    p from_table
    p column_name
    p column_value
end