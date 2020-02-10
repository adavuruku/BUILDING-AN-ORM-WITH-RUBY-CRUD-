wel ="select rt,   re_t,  fr_o FROM kole where kelly= 'grate' "
.gsub(/,(\s+)/,   ',')
.gsub("="," = ")
p wel

#wel ="SELECT * FROM kole JOIN peter on name = persons WHERE salma = 'coledge homes' ORDERBY school desc"
del = wel.scan(/'([^']+)'|(\S+)/).flatten.compact
#del = wel.split(" ").map{|h| h.split(",")}.flatten.select{|y| y.length>0}
p del
if(del[0].casecmp("SELECT").zero?)
    #get all fields to select
    select_fields = del[1].split(",").flatten.select{|y| y.length>0}

    from_table = del[del.find_index{|v| v.casecmp("FROM").zero?}+1]

    join=0
    if (wel =~ /JOIN/i) != nil
        join = del.find_index{|v| v.casecmp("JOIN").zero?}
        join_table = del[join+1]      
        column_dba = del[join+3]
        column_dbb = del[join+5]
    end    
    
    #prep where
    where =0
    column_name =column_value =""
    if (wel =~ /WHERE/i) != nil
        where = del.find_index{|v| v.casecmp("WHERE").zero?}
        column_name = del[where+1]
        column_value = del[where+3]
    end
    
    #prep order
    order_field =order_type=""
    if (wel =~ /ORDERBY/i) != nil
        order = del.find_index{|v| v.casecmp("ORDERBY").zero?}
        order_field = del[order+1]
        order_type = del[order+2].to_sym
    end
    #preparing the query
    #with joins
    if(join>1000)
        MySqliteRequest("nba_player_data.csv")
        .select(select_fields)
        .from(from_table)
        .join(column_dba,join_table,column_dbb)
        .where(column_name,column_value)
        .order(order_type, order_field).run
    end
    #with joins end
    #no join
    if(join==500)
        MySqliteRequest("nba_player_data.csv")
        .select(select_fields)
        .from(from_table)
        .where(column_name,column_value)
        .order(order_type, order_field).run
    end
    p "start"
    p wel
    p column_dba
    p column_dbb
    p column_name
    p column_value
    p select_fields
    p order_field
    p order_type
    p join_table
    p from_table
    p "end"
end