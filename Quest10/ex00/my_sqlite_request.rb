require 'csv'

class MySqliteRequest
    attr_accessor :table, :all_result, :new_all_result,:select_fields, :select_all_fields, :result_from,:path, :del_status, :update_status, :UpdateData
    
    def initialize(filename_db)
        @del_status = @update_status = 0
        @all_result = Array.new
        @select_fields=Array.new
        @result_from=Array.new
        #load a db that contains all table
        path_db = File.join(File.dirname(__FILE__), filename_db)
        file = File.open(path_db, "a+")
        @allTables = eval(file.read())
        file.close()
    end

    def from(table_name)
        @path = File.join(File.dirname(__FILE__), @allTables[table_name])
        @table = CSV.parse(File.read(@path), headers: true)
        @result_from=Array.new
        if @select_all_fields =="*" 
            @select_fields = @table.headers
        end
        @table.each_with_object({}){ |hash1|  @result_from.push((Hash hash1).slice(*@select_fields))}
        @new_all_result = @result_from.to_a
        self
    end

    def where(column_name="", criteria="")
        if @del_status == 1
            if column_name=="" and criteria==""
                type ="all"
                completeDelete(column_name, criteria,type)
            else
                type ="select"
                completeDelete(column_name, criteria,type)
            end
        elsif @update_status ==1
            if column_name=="" and criteria==""
                type ="all"
                completeUpdate(column_name, criteria,type)
            else
                type ="select"
                completeUpdate(column_name, criteria,type)
            end
        else
            @new_all_result = Array.new
            if column_name !="" and criteria !=""
                if @all_result.length > 0
                    @new_all_result = @all_result.select {|row| row[column_name].to_s ==criteria}.to_a
                else
                    @new_all_result = @result_from.select {|row| row[column_name].to_s ==criteria}.to_a
                end
            else
                if @all_result.length > 0  
                    @new_all_result = @all_result.select{|row| row}.to_a
                else
                    @new_all_result = @result_from.select{|row| row}.to_a
                end
            end
        end
        self
    end

    def order(order="",column_name="")
        if order == :asc and column_name !=""
            @new_all_result = @new_all_result.sort_by {|row| row[column_name] || 0 }
        elsif order==:desc and column_name !=""
            @new_all_result = @new_all_result.sort_by {|row| row[column_name] || 0 }.reverse()
        else
            @new_all_result
        end
        self
    end

    def select(*fields)
        if fields.flatten.include? "*"
            @select_all_fields = "*"
        else
            @select_all_fields = ""
            @select_fields = fields.flatten
        end
        self
    end
    #create new record
    def insert(data)
        new_data = data.map{|k, v| v}
        CSV.open(@path,"a") do |csv|
            csv << new_data
        end
        @new_all_result = [{"status" => "ok"}]
        self
    end
    #end of processing Delete
    def completeDelete(column_name, criteria,type)
        if type=="select"
            table = CSV.table(@path)
            table.delete_if do |row|
                row[column_name.to_sym] == criteria
            end
        else
            #empty entire database all record delete
            table = CSV.table(@path)
            table.delete_if do |row|
                table.delete_if{row.length > 0}
            end
        end
        File.open(@path, 'w') do |f|
            f.write(table.to_csv)
        end
        @new_all_result = [{"status" => "ok"}]
        self
    end

    def delete
        @del_status = 1
        self
    end
    #end of delete

    #processing - updates
    def completeUpdate(column_name, criteria,type)
        table = CSV.table(@path)
        if type=="select"
            table.each do |row|
                if row[column_name.to_sym]  == criteria
                    @UpdateData.each{|k,v| row[k.to_sym] = v}
                end
            end
        else
            table.each do |row|
                @UpdateData.each{|k,v| row[k.to_sym] = v}
            end
        end
        File.open(@path, 'w') do |f|
            f.write(table.to_csv)
        end
        @new_all_result = [{"status" => "ok"}]
        self
    end

    def update(data)
        @update_status = 1
        @UpdateData = data
        self
    end
    #end updating here

    def join(column_on_db_a, filename_db_b, column_on_db_b)
        path = File.join(File.dirname(__FILE__), @allTables[filename_db_b])
        tableb = CSV.parse(File.read(path), headers: true)
        if @select_all_fields == "*"
            @select_fields = @select_fields + tableb.headers
        end
        @result_from.each_with_object({}){
            |hash1| 
            tableb.each_with_object({}) {
                    |hash2| 
                    hash1[column_on_db_a] == hash2[column_on_db_b] ? @all_result.push((Hash hash2).merge(Hash hash1).slice(*@select_fields)) : '' 
                }  
        }
        self
    end

    def run
        p @new_all_result
    end
    
end



def MySqliteRequest(file_name)
    return MySqliteRequest.new(file_name)
end

=begin
MySqliteRequest("class.db")
.select("*")
.from("nba_player_data")
.join("name","nba_player","Player")
.where("birth_state","Indiana")
.order(:desc, "height")
.run

MySqliteRequest("class.db")
.select("name","year_start","year_end","height","college")
.from("nba_player_data")
.join("name","nba_player","Player")
.order(:desc, "height")
.run

MySqliteRequest("class.db")
.select("name","year_start","year_end","height","college")
.from("nba_player_data")
.join("name","nba_player","Player")
.where("birth_state","Indiana")
.order(:desc, "height")
.run


MySqliteRequest("class.db")
.select("name","year_start","year_end","height","college")
.from("nba_player_data")
.join("name","nba_player","Player")
.run


MySqliteRequest("class.db")
.select("*").from("nba_player_data")
.where("college","Villanova University")
.order(:desc, "height").run

MySqliteRequest("class.db")
.select("*")
.from("nba_player_data")
.order(:desc, "name").run

MySqliteRequest("class.db")
.select("name", "height")
.from("nba_player_data")
.order(:desc, "name").run

MySqliteRequest("class.db")
.select("name", "height")
.from("nba_player_data").run

=end

=begin

#run insert
insVal = {"name"=>"Abudlraheem Sherif Adavuruku", "year_start"=> "2010", "year_end"=>"2019", "position"=>"A-10", "height"=>"215",
"weight"=>"345", "birth_date"=>"January 10, 1992", "college"=>"Hamad Doley University"}
MySqliteRequest("class.db")
.from("nba_player_data")
.insert(insVal).run



#run update
insVal = {"name"=>"Muhammed John Osuwa", "year_start"=> "1945", "college"=>"Ahmadu Bello University"}
MySqliteRequest("class.db")
.update(insVal)
.from("nba_player_data")
.where("college","Hamad Doley University").run

insVal = {"name"=>"Sherif Adama", "year_start"=> "1945", "college"=>"Abubakar Tafawa Balewa University"}
MySqliteRequest("class.db")
.update(insVal)
.from("nba_player_data")
.where().run


#run delete
MySqliteRequest("class.db")
.delete().from("nba_player_data")
.where("college","Ahmadu Bello University").run

MySqliteRequest("class.db")
.delete().from("nba_player_data")
.where().run

=end